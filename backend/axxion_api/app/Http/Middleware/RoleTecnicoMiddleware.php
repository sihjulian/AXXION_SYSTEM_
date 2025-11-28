<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\Auth;

class RoleTecnicoMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function handle(Request $request, Closure $next): Response
    {
        $user = Auth::user(); // Obtenemos el usuario ya autenticado

        // comprobar si hay un usuario autenticado
        if (!$user) {
            return response()->json(['success' => false, 'message' => 'No autenticado'], 401);
        }

        // Verificar si el usuario tiene el rol de tecnico
        if ($user->roles->contains('codigo', 'tecnico')) {
            return $next($request); // Si tiene el rol, permite el paso
        }

        return response()->json([
            'success' => false,
            'message' => 'Acceso denegado. Se requiere rol de tecnico.'
        ], 403);
    }
}
