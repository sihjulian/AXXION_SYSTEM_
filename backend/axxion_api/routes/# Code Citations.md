# Code Citations

## License: unknown
https://github.com/rslynvry/SGE_Voting/blob/ae55f3f2008b2fac0b68494d7c4e3b367805bbfa/app/Http/Middleware/CheckAuthStudent.php

```
php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Tymon\JWTAuth\Facades
```


## License: unknown
https://github.com/Bouzhar-Abdallah/FileRouge/blob/bb804314d8124582b7f329007b531d90cef6ed65/api/app/Http/Middleware/JwtMiddleware.php

```
class AdministradorMiddleware
{
    /**
     * Handle an incoming request.

```


## License: unknown
https://github.com/fdci-jeff/android-api/blob/b0ba973a2589cf5eb5ed170141d6f1812ab8a492/app/Http/Middleware/JwtMiddleware.php

```
class AdministradorMiddleware
{
    /**
     * Handle an incoming request.

```


## License: unknown
https://github.com/thole3287/BakeryStore/blob/a3076f07166ca6480f47d05c8c9dda595ca52895/app/Http/Middleware/VerifyJWTToken.php

```
class AdministradorMiddleware
{
    /**
     * Handle an incoming request.

```


## License: unknown
https://github.com/paularaielle/mathlearn/blob/2c0fa19c0b3cd8a850aff5fbda9919cf78a6207a/app/Http/Middleware/AdministradorMiddleware.php

```
class AdministradorMiddleware
{
    /**
     * Handle an incoming request.

```


## License: unknown
https://github.com/Bouzhar-Abdallah/FileRouge/blob/bb804314d8124582b7f329007b531d90cef6ed65/api/app/Http/Middleware/JwtMiddleware.php

```
class AdministradorMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        try {
            $user = JWTAuth::parseToken
```


## License: unknown
https://github.com/fdci-jeff/android-api/blob/b0ba973a2589cf5eb5ed170141d6f1812ab8a492/app/Http/Middleware/JwtMiddleware.php

```
class AdministradorMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        try {
            $user = JWTAuth::parseToken
```


## License: unknown
https://github.com/thole3287/BakeryStore/blob/a3076f07166ca6480f47d05c8c9dda595ca52895/app/Http/Middleware/VerifyJWTToken.php

```
class AdministradorMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        try {
            $user = JWTAuth::parseToken
```


## License: unknown
https://github.com/paularaielle/mathlearn/blob/2c0fa19c0b3cd8a850aff5fbda9919cf78a6207a/app/Http/Middleware/AdministradorMiddleware.php

```
class AdministradorMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        try {
            $user = JWTAuth::parseToken
```


## License: unknown
https://github.com/Bouzhar-Abdallah/FileRouge/blob/bb804314d8124582b7f329007b531d90cef6ed65/api/app/Http/Middleware/JwtMiddleware.php

```
class AdministradorMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        try {
            $user = JWTAuth::parseToken()->authenticate();
            if (!$user
```


## License: unknown
https://github.com/fdci-jeff/android-api/blob/b0ba973a2589cf5eb5ed170141d6f1812ab8a492/app/Http/Middleware/JwtMiddleware.php

```
class AdministradorMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        try {
            $user = JWTAuth::parseToken()->authenticate();
            if (!$user
```


## License: unknown
https://github.com/thole3287/BakeryStore/blob/a3076f07166ca6480f47d05c8c9dda595ca52895/app/Http/Middleware/VerifyJWTToken.php

```
class AdministradorMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        try {
            $user = JWTAuth::parseToken()->authenticate();
            if (!$user
```


## License: unknown
https://github.com/paularaielle/mathlearn/blob/2c0fa19c0b3cd8a850aff5fbda9919cf78a6207a/app/Http/Middleware/AdministradorMiddleware.php

```
class AdministradorMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        try {
            $user = JWTAuth::parseToken()->authenticate();
            if (!$user
```


## License: unknown
https://github.com/rslynvry/SGE_Voting/blob/ae55f3f2008b2fac0b68494d7c4e3b367805bbfa/app/Http/Middleware/CheckAuthStudent.php

```
php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response
```


## License: unknown
https://github.com/rslynvry/SGE_Voting/blob/ae55f3f2008b2fac0b68494d7c4e3b367805bbfa/app/Http/Middleware/CheckAuthStudent.php

```
php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;
use
```


## License: unknown
https://github.com/Bouzhar-Abdallah/FileRouge/blob/bb804314d8124582b7f329007b531d90cef6ed65/api/app/Http/Middleware/JwtMiddleware.php

```
request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        try {
```


## License: unknown
https://github.com/Bouzhar-Abdallah/FileRouge/blob/bb804314d8124582b7f329007b531d90cef6ed65/api/app/Http/Middleware/JwtMiddleware.php

```
request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        try {
            $user = JWTAuth::parseToken
```


## License: unknown
https://github.com/rslynvry/SGE_Voting/blob/ae55f3f2008b2fac0b68494d7c4e3b367805bbfa/app/Http/Middleware/CheckAuthStudent.php

```
php

namespace
```


## License: unknown
https://github.com/rslynvry/SGE_Voting/blob/ae55f3f2008b2fac0b68494d7c4e3b367805bbfa/app/Http/Middleware/CheckAuthStudent.php

```
php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions
```


## License: unknown
https://github.com/Bouzhar-Abdallah/FileRouge/blob/bb804314d8124582b7f329007b531d90cef6ed65/api/app/Http/Middleware/JwtMiddleware.php

```
Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  
```


## License: unknown
https://github.com/fdci-jeff/android-api/blob/b0ba973a2589cf5eb5ed170141d6f1812ab8a492/app/Http/Middleware/JwtMiddleware.php

```
Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  
```


## License: unknown
https://github.com/Bouzhar-Abdallah/FileRouge/blob/bb804314d8124582b7f329007b531d90cef6ed65/api/app/Http/Middleware/JwtMiddleware.php

```
Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        try {
            $user = JWTAuth::parseToken
```


## License: unknown
https://github.com/fdci-jeff/android-api/blob/b0ba973a2589cf5eb5ed170141d6f1812ab8a492/app/Http/Middleware/JwtMiddleware.php

```
Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        try {
            $user = JWTAuth::parseToken
```


## License: unknown
https://github.com/diegopacheco/Diego-Pacheco-Sandbox/blob/168c5a9d01db8e5fbf20b92b5855e5183dc37132/scripts/php/composer-fun/hello-world-laravel/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     *
```


## License: MIT
https://github.com/robclancy/presenter/blob/9eae87c0ff075673d358fdc4f44a845f66e65db5/examples/laravel-10.x/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     *
```


## License: MIT
https://github.com/driesvints/driesvints.com/blob/07a248bfc5da9e0236c7565b7a580937f89e52ee/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     *
```


## License: GPL-2.0
https://github.com/eveseat/seat/blob/f6758bc04f8221f3abc997c7f9dd5cb19400f477/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     *
```


## License: GPL-3.0
https://github.com/Vatsim-Scandinavia/controlcenter/blob/84ad309e612491060ceb081ae853e2f8aad64fc1/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     *
```


## License: unknown
https://github.com/diegopacheco/Diego-Pacheco-Sandbox/blob/168c5a9d01db8e5fbf20b92b5855e5183dc37132/scripts/php/composer-fun/hello-world-laravel/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache
```


## License: MIT
https://github.com/robclancy/presenter/blob/9eae87c0ff075673d358fdc4f44a845f66e65db5/examples/laravel-10.x/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache
```


## License: MIT
https://github.com/driesvints/driesvints.com/blob/07a248bfc5da9e0236c7565b7a580937f89e52ee/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache
```


## License: GPL-2.0
https://github.com/eveseat/seat/blob/f6758bc04f8221f3abc997c7f9dd5cb19400f477/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache
```


## License: MIT
https://github.com/laravel-enso/enso/blob/cf82657d4ed5c8df0ed9af4ee226235c67c957ed/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache
```


## License: GPL-3.0
https://github.com/Vatsim-Scandinavia/controlcenter/blob/84ad309e612491060ceb081ae853e2f8aad64fc1/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache
```


## License: unknown
https://github.com/diegopacheco/Diego-Pacheco-Sandbox/blob/168c5a9d01db8e5fbf20b92b5855e5183dc37132/scripts/php/composer-fun/hello-world-laravel/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http
```


## License: MIT
https://github.com/robclancy/presenter/blob/9eae87c0ff075673d358fdc4f44a845f66e65db5/examples/laravel-10.x/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http
```


## License: MIT
https://github.com/driesvints/driesvints.com/blob/07a248bfc5da9e0236c7565b7a580937f89e52ee/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http
```


## License: GPL-2.0
https://github.com/eveseat/seat/blob/f6758bc04f8221f3abc997c7f9dd5cb19400f477/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http
```


## License: MIT
https://github.com/laravel-enso/enso/blob/cf82657d4ed5c8df0ed9af4ee226235c67c957ed/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http
```


## License: unknown
https://github.com/iagocavalcante/financas-api/blob/36335bcbafd9a7126add4b2f85830e3ff7eb7fea/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http
```


## License: unknown
https://github.com/dallinbsmith/school-assignments/blob/004bae407ac0c2a9d205bd7f53176f83ab20fab5/lendio_todo_data/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http
```


## License: unknown
https://github.com/will-helms2/chat-app-backend/blob/10d9414ab6642a8c793ad35ed73aa60364f98f97/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http
```


## License: GPL-3.0
https://github.com/Vatsim-Scandinavia/controlcenter/blob/84ad309e612491060ceb081ae853e2f8aad64fc1/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http
```


## License: unknown
https://github.com/diegopacheco/Diego-Pacheco-Sandbox/blob/168c5a9d01db8e5fbf20b92b5855e5183dc37132/scripts/php/composer-fun/hello-world-laravel/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
```


## License: MIT
https://github.com/robclancy/presenter/blob/9eae87c0ff075673d358fdc4f44a845f66e65db5/examples/laravel-10.x/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
```


## License: MIT
https://github.com/driesvints/driesvints.com/blob/07a248bfc5da9e0236c7565b7a580937f89e52ee/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
```


## License: GPL-2.0
https://github.com/eveseat/seat/blob/f6758bc04f8221f3abc997c7f9dd5cb19400f477/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
```


## License: MIT
https://github.com/laravel-enso/enso/blob/cf82657d4ed5c8df0ed9af4ee226235c67c957ed/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
```


## License: unknown
https://github.com/iagocavalcante/financas-api/blob/36335bcbafd9a7126add4b2f85830e3ff7eb7fea/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
```


## License: unknown
https://github.com/dallinbsmith/school-assignments/blob/004bae407ac0c2a9d205bd7f53176f83ab20fab5/lendio_todo_data/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
```


## License: unknown
https://github.com/will-helms2/chat-app-backend/blob/10d9414ab6642a8c793ad35ed73aa60364f98f97/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
```


## License: GPL-3.0
https://github.com/Vatsim-Scandinavia/controlcenter/blob/84ad309e612491060ceb081ae853e2f8aad64fc1/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
```


## License: unknown
https://github.com/diegopacheco/Diego-Pacheco-Sandbox/blob/168c5a9d01db8e5fbf20b92b5855e5183dc37132/scripts/php/composer-fun/hello-world-laravel/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
        'jwt.auth' => \Tymon\JWTAuth\Http\
```


## License: MIT
https://github.com/robclancy/presenter/blob/9eae87c0ff075673d358fdc4f44a845f66e65db5/examples/laravel-10.x/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
        'jwt.auth' => \Tymon\JWTAuth\Http\
```


## License: MIT
https://github.com/driesvints/driesvints.com/blob/07a248bfc5da9e0236c7565b7a580937f89e52ee/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
        'jwt.auth' => \Tymon\JWTAuth\Http\
```


## License: GPL-2.0
https://github.com/eveseat/seat/blob/f6758bc04f8221f3abc997c7f9dd5cb19400f477/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
        'jwt.auth' => \Tymon\JWTAuth\Http\
```


## License: MIT
https://github.com/laravel-enso/enso/blob/cf82657d4ed5c8df0ed9af4ee226235c67c957ed/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
        'jwt.auth' => \Tymon\JWTAuth\Http\
```


## License: unknown
https://github.com/iagocavalcante/financas-api/blob/36335bcbafd9a7126add4b2f85830e3ff7eb7fea/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
        'jwt.auth' => \Tymon\JWTAuth\Http\
```


## License: unknown
https://github.com/dallinbsmith/school-assignments/blob/004bae407ac0c2a9d205bd7f53176f83ab20fab5/lendio_todo_data/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
        'jwt.auth' => \Tymon\JWTAuth\Http\
```


## License: unknown
https://github.com/will-helms2/chat-app-backend/blob/10d9414ab6642a8c793ad35ed73aa60364f98f97/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
        'jwt.auth' => \Tymon\JWTAuth\Http\
```


## License: GPL-3.0
https://github.com/Vatsim-Scandinavia/controlcenter/blob/84ad309e612491060ceb081ae853e2f8aad64fc1/app/Http/Kernel.php

```
's route middleware.
     *
     * These middleware may be assigned to groups or used individually.
     *
     * @var array<string, class-string|string>
     */
    protected $middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'precognitive' => \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
        'jwt.auth' => \Tymon\JWTAuth\Http\
```

