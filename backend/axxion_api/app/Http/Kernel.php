<?php

namespace App\Http;

use Illuminate\Foundation\Http\Kernel as HttpKernel;
use Illuminate\Routing\Middleware\SubstituteBindings;
use Illuminate\Auth\Middleware\Authenticate;
use Illuminate\Auth\Middleware\AuthenticateWithBasicAuth;
use Illuminate\Http\Middleware\SetCacheHeaders;
use Illuminate\Auth\Middleware\Authorize;
use App\Http\Middleware\RedirectIfAuthenticated;
use Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests;
use Illuminate\Routing\Middleware\ValidateSignature;
use Illuminate\Routing\Middleware\ThrottleRequests;
use Illuminate\Auth\Middleware\EnsureEmailIsVerified;
use Tymon\JWTAuth\Http\Middleware\Authenticate as JWTAuthenticate;
use App\Http\Middleware\RoleAdminMiddleware;
use App\Http\Middleware\RoleAuxiliarMiddleware;
use App\Http\Middleware\RoleTecnicoMiddleware;

class Kernel extends HttpKernel
{
    /**
     * The application's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     * 
     * Note: En Laravel 11, los middlewares se registran en bootstrap/app.php
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        // Los middlewares personalizados ahora se registran en bootstrap/app.php
    ];
}