<?php

namespace App\Http\Controllers;

use App\Models\Renta;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class ReporteRentaController extends Controller
{
    // REPORTE: Tablero Principal
    public function resumenGeneral() 
    {
        // Calcular rentas activas
        $rentasActivas = Renta::where('estado_renta', 'EnCurso')->count();
        // Calcular rentas atrasadas
        $rentasAtrasadas = Renta::where('estado_renta', 'EnCurso')
        ->whereDate('fecha_fin_prevista', '<', Carbon::today())
        ->count();
        // Dinero total en garantía retenido
        $garantiasRetenidas = Renta::where('estado_renta', 'EnCurso')
        ->sum('deposito_garantia');
        
        return response()->json([
            'total_rentas_activas' => $rentasActivas,
            'alertas_atrasadas' => $rentasAtrasadas,
            'dinero_en_garantias' => $garantiasRetenidas,
        ]);
    }
    // REPORTE: Operativo 
    public function obtenerRentasAtrasadas()
    {
        $atrasadas = Renta::where('estado_renta', 'EnCurso')
        ->whereDate('fecha_fin_prevista', '<', Carbon::today())
        ->with(['cliente:id,nombre,telefono_principal,correo_electronico'])
        ->get()
        ->map(function ($renta) {
            return [
                'folio' => $renta->id,
                'cliente' => $renta->cliente->nombre,
                'contacto' => $renta->cliente->telefono_principal,
                'fecha_debio_entregar'=> $renta->fecha_fin_prevista->format('d/m/Y'),
                'dias_retraso' => Carbon::now()->diffInDays($renta->fecha_fin_prevista),
                'monto_pendiente' => $renta->monto_total_renta
            ];
        });
        return response()->json($atrasadas);
    }
    // REPORTE: Financiero - Ingresos por Mes
    public function ingresosPorMes()
    {
        // Usamos selectRaw para consultas de agregación
        $ingresos = Renta::selectRaw('
        YEAR(fecha_inicio) as anio,
        MONTH(fecha_inicio as mes,
        SUM(monto_total_renta) as total
        ')
        ->groupBy('anio', 'mes')
        ->orderBy('anio', 'desc')
        ->orderBy('mes', 'desc')
        ->limit(12)
        ->get();
        // Mapeamos para que el frontend
        $datosGrafico = $ingresos->map(function ($item) {
            return [
                'etiqueta' => $item->mes . '/' . $item->anio,
                'valor' => $item->total
            ];
        });
        return response()->json($datosGrafico);
    }
    // REPORTE: Activos - Inventario más utilizado
    public function topEquiposRentados()
    {
        $ranking = DB::table('renta_inventario_item')
            ->join('inventario_items', 'renta_inventario_item.inventario_item_id', '=', 'inventario_items.id')
            ->join('productos', 'inventario_items.producto_id', '=', 'productos.id') 
            ->select(
                'productos.nombre', // Nombre legible del producto
                DB::raw('count(*) as total_rentas'), // Cuántas veces se ha alquilado
                DB::raw('SUM(renta_inventario_item.precio_renta_item) as ingresos_generados') // Cuánto dinero ha traído
            )
            ->groupBy('productos.id', 'productos.nombre')
            ->orderByDesc('total_rentas')
            ->limit(10)
            ->get();

        return response()->json($ranking);
    }
    // REPORTE: Disponibilidad del Inventario
    public function estadoInventario()
    {
        // Esto cuenta cuántos ítems hay en cada estado: Disponible, Rentado, etc.
        $estados = DB::table('inventario_items')
            ->select('estado_item', DB::raw('count(*) as total'))
            ->groupBy('estado_item')
            ->get();

        // Formateamos para un gráfico de pastel (Pie Chart)
        $data = $estados->map(function($item) {
            return [
                'estado' => $item->estado_item,
                'cantidad' => $item->total
            ];
        });

        return response()->json($data);
    }

        public function roiPorEquipo()
    {
        $analisis = DB::table('inventario_items')
            ->join('renta_inventario_item', 'inventario_items.id', '=', 'renta_inventario_item.inventario_item_id')
            ->select(
                'inventario_items.numero_serie',
                'inventario_items.costo_adquisicion',
                DB::raw('SUM(renta_inventario_item.precio_renta_item) as total_ingresos')
            )
            ->whereNotNull('inventario_items.costo_adquisicion') // Ignoramos si no registraste el costo
            ->groupBy('inventario_items.id', 'inventario_items.numero_serie', 'inventario_items.costo_adquisicion')
            ->get()
            ->map(function ($item) {
                // Cálculo de Ingeniería Financiera simple
                $gananciaNeta = $item->total_ingresos - $item->costo_adquisicion;
                $porcentajeRecuperacion = ($item->total_ingresos / $item->costo_adquisicion) * 100;

                return [
                    'serie' => $item->numero_serie,
                    'costo' => $item->costo_adquisicion,
                    'ingreso_acumulado' => $item->total_ingresos,
                    'es_rentable' => $gananciaNeta > 0, // Booleano: ¿Ya dio ganancia?
                    'roi_porcentaje' => round($porcentajeRecuperacion, 2) . '%'
                ];
            });

        return response()->json($analisis);
    }
}