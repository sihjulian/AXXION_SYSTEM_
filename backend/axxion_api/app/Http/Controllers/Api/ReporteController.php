<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Usuario;
use App\Models\Mantenimiento;
use App\Models\Renta;
use App\Models\Categoria;
use App\Models\Producto;
use Illuminate\Http\Request;

class ReporteController extends Controller
{
    public function inventario()
    {
        try {
            $productos = Producto::all();
            return response()->json($productos);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al obtener los productos: ' . $e->getMessage()], 500);
        }
    }


        public function usuarios()
    {
        $usuarios = Usuario::with('roles')->get();
        return response()->json([
            'data' => $usuarios,
            'status' => 200
        ]);
    }

    public function rentas()
    {
        $rentas = Renta::with(['cliente','equipos'])->get();
        return response()->json([
            'data' => $rentas,
            'status' => 200
        ]);
    }

    public function metrics()
{
    $totalItems = Producto::count();
    $valorTotal = Producto::sum('valor_actual');
    $equiposDisponibles = Producto::where('condicion', 'Excelente')->count();
    
    return response()->json([
        'items_totales' => $totalItems,
        'valor_total' => $valorTotal,
        'equipos_disponibles' => $equiposDisponibles,
    ]);
}

public function metricsAlq()
{
    $totalItems = Renta::count();
    $valorTotal = Renta::sum('monto_total_renta');
    return response()->json([
        'items_totales' => $totalItems,
        'valor_total' => $valorTotal
    ]);
}
}