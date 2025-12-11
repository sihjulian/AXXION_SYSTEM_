<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Mantenimiento;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Carbon\Carbon;

class ReporteMantController extends Controller
{
    public function reporteEficiencia()
    {
        // Filtramos solo los mantenimientos terminados para tener datos reales
        $mantenimientos = Mantenimiento::whereNotNull('fecha_fin_real')
            ->whereNotNull('fecha_inicio')
            ->get();

        $datos = $mantenimientos->map(function ($item) {
            // Calculamos la diferencia en días
            $inicio = Carbon::parse($item->fecha_inicio);
            $finReal = Carbon::parse($item->fecha_fin_real);
            $finPrevista = Carbon::parse($item->fecha_fin_prevista);

            return [
                'id' => $item->id,
                'item' => $item->inventarioItem->nombre ?? 'Item #' . $item->inventario_item_id,
                'dias_reparacion' => intval(abs($finReal->diffInDays($inicio))),
                'retraso_dias' => abs($finReal->greaterThan($finPrevista))
                    ? abs($finReal->diffInDays($finPrevista))
                    : 0,
            ];
        });

        $totalRegistros = $datos->count();
        $cantidadAtrasos = $datos->where('retraso_dias', '>', 0)->count();

        $porcentajeAtrasos = $totalRegistros > 0
            ? ($cantidadAtrasos / $totalRegistros) * 100
            : 0;

        $promedioDiasReparacion = $datos->avg('dias_reparacion') ?? 0;

        return response()->json([
            'resumen' => [
                'tiempo_promedio_reparacion_dias' => intval(abs($promedioDiasReparacion), 2),
                'tasa_de_incumplimiento' => round($porcentajeAtrasos, 2) . '%',
                'total_analizados' => $totalRegistros,
            ],
            'detalle' => $datos
        ]);
    }

    /**
     * Análisis Financiero - Control de Costos
     * 
     * Calcula:
     * 1. Desviación Presupuestaria (costo_estimado vs costo_real)
     * 2. TCO (Total Cost of Ownership) por Activo
     * 
     * Detecta:
     * - Problemas de planificación presupuestaria
     * - "Activos vampiro" (equipos que cuestan más mantener que reemplazar)
     */
    public function analisisFinanciero()
    {
        try {
            // Obtenemos todos los mantenimientos con costos reales
            $mantenimientos = Mantenimiento::whereNotNull('costo_real')
                ->with('inventarioItem')
                ->get();

            // === 1. DESVIACIÓN PRESUPUESTARIA ===
            $desviaciones = $mantenimientos->map(function ($item) {
                $costoEstimado = $item->costo_estimado ?? 0;
                $costoReal = $item->costo_real ?? 0;
                $desviacion = $costoReal - $costoEstimado;
                $desviacionPorcentaje = $costoEstimado > 0
                    ? (($desviacion / $costoEstimado) * 100)
                    : 0;

                return [
                    'mantenimiento_id' => $item->id,
                    'item' => $item->inventarioItem->nombre ?? 'Item #' . $item->inventario_item_id,
                    'costo_estimado' => round($costoEstimado, 2),
                    'costo_real' => round($costoReal, 2),
                    'desviacion' => round($desviacion, 2),
                    'desviacion_porcentaje' => round($desviacionPorcentaje, 2),
                    'subestimado' => $desviacion > 0,
                ];
            });

            // Métricas de desviación presupuestaria
            $totalMantenimientos = $desviaciones->count();
            $subestimados = $desviaciones->where('subestimado', true)->count();
            $porcentajeSubestimacion = $totalMantenimientos > 0
                ? round(($subestimados / $totalMantenimientos) * 100, 2)
                : 0;

            $desviacionPromedioMonto = $desviaciones->avg('desviacion');
            $desviacionPromedioPorcentaje = $desviaciones->avg('desviacion_porcentaje');

            // === 2. TCO (Total Cost of Ownership) POR ACTIVO ===
            $tcosPorActivo = $mantenimientos
                ->groupBy('inventario_item_id')
                ->map(function ($mantsPorActivo, $itemId) {
                    $primerMant = $mantsPorActivo->first();
                    $nombreItem = $primerMant->inventarioItem->nombre ?? 'Item #' . $itemId;

                    // Calculamos el TCO acumulado
                    $tcoTotal = $mantsPorActivo->sum('costo_real');
                    $cantidadReparaciones = $mantsPorActivo->count();
                    $costoPromedioReparacion = $cantidadReparaciones > 0
                        ? $tcoTotal / $cantidadReparaciones
                        : 0;

                    return [
                        'inventario_item_id' => $itemId,
                        'nombre_item' => $nombreItem,
                        'tco_total' => round($tcoTotal, 2),
                        'cantidad_reparaciones' => $cantidadReparaciones,
                        'costo_promedio_reparacion' => round($costoPromedioReparacion, 2),
                        'mantenimientos' => $mantsPorActivo->pluck('id')->toArray(),
                    ];
                })
                ->sortByDesc('tco_total')
                ->values();

            // Identificar "activos vampiro" (top 10 más costosos)
            $activosVampiro = $tcosPorActivo->take(10);

            // === RESUMEN GENERAL ===
            $resumen = [
                // Desviación Presupuestaria
                'desviacion_presupuestaria' => [
                    'total_mantenimientos_analizados' => $totalMantenimientos,
                    'mantenimientos_subestimados' => $subestimados,
                    'porcentaje_subestimacion' => $porcentajeSubestimacion . '%',
                    'desviacion_promedio_monto' => round($desviacionPromedioMonto, 2),
                    'desviacion_promedio_porcentaje' => round($desviacionPromedioPorcentaje, 2) . '%',
                    'alerta_planificacion' => $porcentajeSubestimacion > 50
                        ? 'CRÍTICO: Más del 50% de los mantenimientos están subestimados'
                        : ($porcentajeSubestimacion > 30
                            ? 'ADVERTENCIA: Revisar proceso de estimación de costos'
                            : 'NORMAL: Estimaciones dentro del rango aceptable'),
                ],
                // TCO
                'tco_general' => [
                    'total_activos_analizados' => $tcosPorActivo->count(),
                    'tco_promedio_por_activo' => round($tcosPorActivo->avg('tco_total'), 2),
                    'tco_maximo' => round($tcosPorActivo->max('tco_total'), 2),
                    'activos_vampiro_detectados' => $activosVampiro->count(),
                    'recomendacion' => $activosVampiro->count() > 0
                        ? 'Revisar activos con TCO elevado para evaluar reemplazo'
                        : 'No se detectaron activos con TCO crítico',
                ],
            ];

            return response()->json([
                'resumen' => $resumen,
                'desviacion_presupuestaria' => [
                    'detalle' => $desviaciones,
                ],
                'tco_por_activo' => [
                    'todos' => $tcosPorActivo,
                    'activos_vampiro' => $activosVampiro,
                ],
            ]);

        } catch (\Exception $e) {
            Log::error('Error en análisis financiero: ' . $e->getMessage());
            return response()->json([
                'error' => 'Error al generar análisis financiero',
                'mensaje' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Ratio de Reactividad - Análisis Preventivo vs Correctivo
     * 
     * Lógica: Es mejor prevenir que lamentar. Un sistema sano tiene más 
     * mantenimiento preventivo que correctivo.
     * 
     * Calcula:
     * - Ratio Preventivo vs Correctivo
     * - Porcentaje de cada tipo de mantenimiento
     * - Nivel de reactividad del sistema
     * 
     * Valor: Si el 80% de los mantenimientos son "Correctivos", la gestión 
     * es un caos reactivo. El objetivo es invertir esa balanza hacia lo "Preventivo".
     * 
     * Analogía: Salud dental - es más barato ir a limpiezas regulares (preventivo) 
     * que ir de urgencia por un dolor de muela para una extracción (correctivo).
     */
    public function ratioReactividad()
    {
        try {
            // Obtenemos todos los mantenimientos
            $mantenimientos = Mantenimiento::all();
            $totalMantenimientos = $mantenimientos->count();

            if ($totalMantenimientos === 0) {
                return response()->json([
                    'mensaje' => 'No hay datos de mantenimientos para analizar',
                    'resumen' => null,
                    'detalle' => null
                ]);
            }

            // Conteo por tipo de mantenimiento
            $conteoPorTipo = $mantenimientos
                ->groupBy('tipo_mantenimiento')
                ->map(function ($items, $tipo) use ($totalMantenimientos) {
                    $cantidad = $items->count();
                    $porcentaje = ($cantidad / $totalMantenimientos) * 100;

                    return [
                        'tipo' => $tipo,
                        'cantidad' => $cantidad,
                        'porcentaje' => round($porcentaje, 2),
                    ];
                })
                ->values();

            // Extraemos los valores específicos de Preventivo y Correctivo
            $preventivo = $mantenimientos->where('tipo_mantenimiento', 'Preventivo')->count();
            $correctivo = $mantenimientos->where('tipo_mantenimiento', 'Correctivo')->count();

            $porcentajePreventivo = $totalMantenimientos > 0
                ? round(($preventivo / $totalMantenimientos) * 100, 2)
                : 0;
            $porcentajeCorrectivo = $totalMantenimientos > 0
                ? round(($correctivo / $totalMantenimientos) * 100, 2)
                : 0;

            // Calculamos el ratio Preventivo:Correctivo
            // Ejemplo: Si hay 60 preventivos y 40 correctivos = Ratio 1.5:1 (60/40)
            $ratio = $correctivo > 0
                ? round($preventivo / $correctivo, 2)
                : ($preventivo > 0 ? 'Infinito (solo preventivos)' : 0);

            // === EVALUACIÓN DEL NIVEL DE REACTIVIDAD ===
            $nivelReactividad = '';
            $estado = '';
            $recomendacion = '';
            $color = '';

            if ($porcentajeCorrectivo >= 80) {
                $nivelReactividad = 'CRÍTICO - Gestión Reactiva en Caos';
                $estado = 'URGENTE';
                $color = 'red';
                $recomendacion = 'Su sistema está en modo de emergencia constante. El 80% o más de los mantenimientos son correctivos. Es imperativo implementar un plan de mantenimiento preventivo inmediatamente. Está gastando más tiempo y dinero "apagando incendios" que previniéndolos.';
            } elseif ($porcentajeCorrectivo >= 60) {
                $nivelReactividad = 'ALTO - Gestión Mayormente Reactiva';
                $estado = 'ATENCIÓN';
                $color = 'orange';
                $recomendacion = 'Su gestión es predominantemente reactiva. Más del 60% de los mantenimientos son correctivos. Esto indica falta de planificación. Implemente calendarios de mantenimiento preventivo para reducir fallas inesperadas.';
            } elseif ($porcentajeCorrectivo >= 40) {
                $nivelReactividad = 'MODERADO - Balance Mejorable';
                $estado = 'REGULAR';
                $color = 'yellow';
                $recomendacion = 'Hay un balance entre preventivo y correctivo, pero aún hay margen de mejora. Trabaje en fortalecer el programa preventivo para reducir los mantenimientos correctivos por debajo del 30%.';
            } elseif ($porcentajeCorrectivo >= 20) {
                $nivelReactividad = 'BUENO - Gestión Proactiva';
                $estado = 'SALUDABLE';
                $color = 'green';
                $recomendacion = 'Excelente gestión de mantenimiento. El sistema está balanceado hacia lo preventivo. Mantenga esta estrategia y busque optimizar aún más los calendarios de mantenimiento.';
            } else {
                $nivelReactividad = 'ÓPTIMO - Gestión Altamente Preventiva';
                $estado = 'EXCELENTE';
                $color = 'green';
                $recomendacion = 'Felicidades, su sistema de mantenimiento es altamente preventivo. Menos del 20% de los mantenimientos son correctivos. Esto indica una gestión proactiva y eficiente. Continue monitoreando para mantener este estándar.';
            }

            // === RESUMEN GENERAL ===
            $resumen = [
                'total_mantenimientos' => $totalMantenimientos,
                'preventivo' => [
                    'cantidad' => $preventivo,
                    'porcentaje' => $porcentajePreventivo . '%',
                ],
                'correctivo' => [
                    'cantidad' => $correctivo,
                    'porcentaje' => $porcentajeCorrectivo . '%',
                ],
                'ratio_preventivo_correctivo' => $ratio . ':1',
                'ratio_interpretacion' => $ratio !== 0 && $ratio !== 'Infinito (solo preventivos)'
                    ? ($ratio > 1
                        ? "Por cada mantenimiento correctivo hay {$ratio} preventivos (SALUDABLE)"
                        : "Por cada mantenimiento preventivo hay " . round(1 / $ratio, 2) . " correctivos (REACTIVO)")
                    : 'N/A',
                'evaluacion' => [
                    'nivel_reactividad' => $nivelReactividad,
                    'estado' => $estado,
                    'color_indicador' => $color,
                    'recomendacion' => $recomendacion,
                ],
                'objetivo_recomendado' => [
                    'preventivo_objetivo' => '70-80%',
                    'correctivo_objetivo' => '20-30%',
                    'mensaje' => 'El objetivo ideal es tener entre 70-80% de mantenimientos preventivos y solo 20-30% correctivos.',
                ],
            ];

            return response()->json([
                'resumen' => $resumen,
                'detalle_por_tipo' => $conteoPorTipo,
                'analogia' => [
                    'titulo' => 'Salud Dental',
                    'explicacion' => 'Es como la salud dental: ir a limpiezas regulares (preventivo) es más barato y menos doloroso que ir de urgencia por un dolor de muela para una extracción (correctivo). El mantenimiento preventivo ahorra tiempo, dinero y dolores de cabeza.',
                ],
            ]);

        } catch (\Exception $e) {
            Log::error('Error en ratio de reactividad: ' . $e->getMessage());
            return response()->json([
                'error' => 'Error al generar ratio de reactividad',
                'mensaje' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Ocupación Técnica - Optimización de Equipo Humano
     * 
     * Lógica: Optimizar al equipo humano analizando la carga de trabajo
     * y el flujo de reparaciones.
     * 
     * Calcula:
     * 1. Ocupación por Técnico - Carga de trabajo por responsable y estado
     * 2. Pipeline de Reparaciones - Flujo del proceso de mantenimiento
     * 
     * Valor: 
     * - Detecta desbalance en la carga de trabajo entre técnicos
     * - Identifica cuellos de botella en el proceso
     * - Permite balancear asignaciones para optimizar el equipo
     */
    public function ocupacionTecnica()
    {
        try {
            // Obtenemos todos los mantenimientos con su responsable
            $mantenimientos = Mantenimiento::with('responsable')->get();
            $totalMantenimientos = $mantenimientos->count();

            if ($totalMantenimientos === 0) {
                return response()->json([
                    'mensaje' => 'No hay datos de mantenimientos para analizar',
                    'ocupacion_por_tecnico' => null,
                    'pipeline_reparaciones' => null
                ]);
            }

            // === 1. OCUPACIÓN POR TÉCNICO ===
            $ocupacionPorTecnico = $mantenimientos
                ->groupBy('responsable_id')
                ->map(function ($mantsPorTecnico, $responsableId) use ($totalMantenimientos) {
                    $primerMant = $mantsPorTecnico->first();
                    $nombreTecnico = $primerMant->responsable->name ?? 'Técnico #' . $responsableId;

                    // Contamos por estado
                    $porEstado = $mantsPorTecnico->groupBy('estado_mantenimiento')->map(function ($items, $estado) {
                        return [
                            'estado' => $estado,
                            'cantidad' => $items->count(),
                        ];
                    })->values();

                    // Extraemos cantidades específicas
                    $pendiente = $mantsPorTecnico->where('estado_mantenimiento', 'Pendiente')->count();
                    $enProgreso = $mantsPorTecnico->where('estado_mantenimiento', 'En Progreso')->count();
                    $esperandoRepuestos = $mantsPorTecnico->where('estado_mantenimiento', 'Esperando Repuestos')->count();
                    $terminado = $mantsPorTecnico->where('estado_mantenimiento', 'Terminado')->count();

                    $totalAsignado = $mantsPorTecnico->count();
                    $enCurso = $pendiente + $enProgreso + $esperandoRepuestos; // lo que no está terminado
    
                    // Calculamos el porcentaje de ocupación
                    $porcentajeOcupacion = $totalMantenimientos > 0
                        ? round(($totalAsignado / $totalMantenimientos) * 100, 2)
                        : 0;

                    return [
                        'responsable_id' => $responsableId,
                        'nombre_tecnico' => $nombreTecnico,
                        'total_asignado' => $totalAsignado,
                        'en_curso' => $enCurso, // Activos no terminados
                        'terminados' => $terminado,
                        'porcentaje_ocupacion' => $porcentajeOcupacion,
                        'detalle_por_estado' => [
                            'pendiente' => $pendiente,
                            'en_progreso' => $enProgreso,
                            'esperando_repuestos' => $esperandoRepuestos,
                            'terminado' => $terminado,
                        ],
                        'estados_completos' => $porEstado,
                    ];
                })
                ->sortByDesc('en_curso')
                ->values();

            // Detectar desbalance en la carga de trabajo
            $maxEnCurso = $ocupacionPorTecnico->max('en_curso');
            $minEnCurso = $ocupacionPorTecnico->min('en_curso');
            $desbalance = $maxEnCurso - $minEnCurso;

            $alertaDesbalance = '';
            if ($desbalance >= 15) {
                $alertaDesbalance = 'CRÍTICO: Hay una diferencia de ' . $desbalance . ' mantenimientos en curso entre técnicos. Es urgente rebalancear la carga de trabajo.';
            } elseif ($desbalance >= 10) {
                $alertaDesbalance = 'ADVERTENCIA: Diferencia de ' . $desbalance . ' mantenimientos. Se recomienda redistribuir asignaciones.';
            } elseif ($desbalance >= 5) {
                $alertaDesbalance = 'MODERADO: Diferencia de ' . $desbalance . ' mantenimientos. Considere balancear la carga.';
            } else {
                $alertaDesbalance = 'BALANCEADO: La carga de trabajo está bien distribuida entre los técnicos.';
            }

            // === 2. PIPELINE DE REPARACIONES (EMBUDO) ===
            $pipelineReparaciones = $mantenimientos
                ->groupBy('estado_mantenimiento')
                ->map(function ($items, $estado) use ($totalMantenimientos) {
                    $cantidad = $items->count();
                    $porcentaje = ($cantidad / $totalMantenimientos) * 100;

                    return [
                        'estado' => $estado,
                        'cantidad' => $cantidad,
                        'porcentaje' => round($porcentaje, 2),
                    ];
                })
                ->values();

            // Ordenar el pipeline en el orden lógico del proceso
            $ordenPipeline = ['Pendiente', 'En Progreso', 'Esperando Repuestos', 'Terminado', 'Cancelado'];
            $pipelineOrdenado = collect($ordenPipeline)->map(function ($estado) use ($pipelineReparaciones) {
                $estadoData = $pipelineReparaciones->firstWhere('estado', $estado);
                return $estadoData ?? [
                    'estado' => $estado,
                    'cantidad' => 0,
                    'porcentaje' => 0,
                ];
            });

            // Identificar cuellos de botella
            $mayorCantidad = $pipelineReparaciones->max('cantidad');
            $cuellosBottella = $pipelineReparaciones
                ->where('cantidad', '>=', $mayorCantidad * 0.7)
                ->where('estado', '!=', 'Terminado') // Terminado no es un cuello de botella
                ->pluck('estado');

            $alertaCuelloBottella = $cuellosBottella->count() > 0
                ? 'Cuellos de botella detectados en: ' . $cuellosBottella->implode(', ')
                : 'No se detectaron cuellos de botella significativos';

            // === RESUMEN GENERAL ===
            $resumen = [
                'total_mantenimientos' => $totalMantenimientos,
                'total_tecnicos' => $ocupacionPorTecnico->count(),
                'carga_trabajo' => [
                    'tecnico_mas_ocupado' => $ocupacionPorTecnico->first()['nombre_tecnico'] ?? 'N/A',
                    'max_en_curso' => $maxEnCurso,
                    'tecnico_menos_ocupado' => $ocupacionPorTecnico->last()['nombre_tecnico'] ?? 'N/A',
                    'min_en_curso' => $minEnCurso,
                    'diferencia' => $desbalance,
                    'alerta_desbalance' => $alertaDesbalance,
                ],
                'pipeline' => [
                    'total_en_pipeline' => $totalMantenimientos,
                    'cuellos_botella' => $cuellosBottella->toArray(),
                    'alerta_cuello_botella' => $alertaCuelloBottella,
                ],
                'recomendaciones' => [
                    'balanceo' => $desbalance >= 10
                        ? 'Se recomienda reasignar mantenimientos del técnico más ocupado al menos ocupado'
                        : 'La distribución de carga es aceptable',
                    'optimizacion' => $cuellosBottella->count() > 0
                        ? 'Revisar el proceso en las etapas: ' . $cuellosBottella->implode(', ') . ' para reducir el tiempo de permanencia'
                        : 'El flujo del pipeline es saludable',
                ],
            ];

            return response()->json([
                'resumen' => $resumen,
                'ocupacion_por_tecnico' => $ocupacionPorTecnico,
                'pipeline_reparaciones' => [
                    'datos_ordenados' => $pipelineOrdenado,
                    'datos_brutos' => $pipelineReparaciones,
                ],
                'visualizacion' => [
                    'tipo_grafico_recomendado' => 'barras_horizontales',
                    'descripcion' => 'Un gráfico de barras mostrando el flujo: Pendiente -> En Progreso -> Esperando Repuestos -> Terminado. Las barras más grandes (excepto Terminado) indican cuellos de botella.',
                    'labels' => $pipelineOrdenado->pluck('estado')->toArray(),
                    'valores' => $pipelineOrdenado->pluck('cantidad')->toArray(),
                ],
            ]);

        } catch (\Exception $e) {
            Log::error('Error en ocupación técnica: ' . $e->getMessage());
            return response()->json([
                'error' => 'Error al generar ocupación técnica',
                'mensaje' => $e->getMessage()
            ], 500);
        }
    }
}
