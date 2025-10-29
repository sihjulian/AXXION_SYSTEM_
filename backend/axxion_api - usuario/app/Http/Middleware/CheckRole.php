<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;

class CheckRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, ...$roles): Response
    {
        try {
            $user = JWTAuth::parseToken()->authenticate();
            
            if (!$user) {
                return response()->json(['error' => 'Usuario no autenticado'], 401);
            }

            // Verificar si el usuario tiene alguno de los roles requeridos
            $userRoles = $user->roles()->pluck('codigo')->toArray();
            
            if (empty($roles)) {
                // Si no se especifican roles, solo verificar autenticación
                return $next($request);
            }

            $hasRole = false;
            foreach ($roles as $role) {
                if (in_array($role, $userRoles)) {
                    $hasRole = true;
                    break;
                }
            }

            if (!$hasRole) {
                return response()->json([
                    'error' => 'Acceso denegado. No tienes los permisos necesarios.',
                    'required_roles' => $roles,
                    'user_roles' => $userRoles
                ], 403);
            }

            return $next($request);

        } catch (TokenExpiredException $e) {
            return response()->json(['error' => 'Token expirado'], 401);
        } catch (TokenInvalidException $e) {
            return response()->json(['error' => 'Token inválido'], 401);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Token no encontrado'], 401);
        }
    }
}
