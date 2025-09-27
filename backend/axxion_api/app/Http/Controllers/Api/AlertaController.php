<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Mantenimiento;
use App\Models\Renta;
use App\Models\Producto;
use Illuminate\Http\Request;

class AlertaController extends Controller
{
public function index()
    {
        $hoy = now();
        $producto = Producto::whereDate('fecha_compra', '<=', $hoy->copy()->addDays($hoy->day >= 24 ? 15 : 7))
            ->get()
            ->map(function($item) {
                return [
                    'tipo' => 'Inventario',
                    'nivel' => 'Informativa',
                    'titulo' => "Antigüedad del equipo de {$item->nombre}",
                    'mensaje' => "El equipo {$item->nombre} ({$item->modelo}) tiene más de 1 año desde su compra.",
                    'referencia' => "Equipo ID: {$item->id}",
                    'fecha' => $item->fecha_compra,
                ];
            });
        $mantenimientos = Mantenimiento::where('estado_mantenimiento', 'Programado')
            ->whereDate('fecha_inicio', '<=', $hoy)
            ->orWhere(function($q) use ($hoy) {
                $q->where('estado_mantenimiento', 'EnProceso')
                ->whereDate('fecha_fin_prevista', '<', $hoy);
            })
            ->get()
            ->map(function($m) {
                return [
                    'tipo' => 'Mantenimiento',
                    'nivel' => $m->estado_mantenimiento === 'Programado' ? 'Informativa' : 'Crítica',
                    'titulo' => "Mantenimiento {$m->tipo_mantenimiento} pendiente",
                    'mensaje' => $m->descripcion_problema ?? "Revisar estado del equipo",
                    'referencia' => "Equipo ID: {$m->inventario_item_id}",
                    'fecha' => $m->fecha_inicio,
                ];
            });
        $rentas = Renta::where('estado_renta', 'Programada')
            ->whereDate('fecha_inicio', '<=', $hoy)
            ->orWhere(function($q) use ($hoy) {
                $q->where('estado_renta', 'EnCurso')
                ->whereDate('fecha_fin_prevista', '<', $hoy);
            })
            ->get()
            ->map(function($r) {
                return [
                    'tipo' => 'Alquiler',
                    'nivel' => $r->estado_renta === 'Programada' ? 'Advertencia' : 'Crítica',
                    'titulo' => "Renta #{$r->id} {$r->estado_renta}",
                    'mensaje' => $r->notas ?? 'Revisar estado de la renta',
                    'referencia' => "Cliente: {$r->cliente->nombre} {$r->cliente->apellido1}",
                    'fecha' => $r->fecha_inicio,
                ];
            });

        $alertas = $producto->merge($mantenimientos)->merge($rentas);

        return response()->json([
            'alertas' => $alertas,
            'total' => $alertas->count()
        ]);
    }
}