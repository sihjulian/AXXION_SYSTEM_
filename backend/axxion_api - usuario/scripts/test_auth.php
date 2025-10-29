<?php

/**
 * Script de prueba para verificar la autenticación JWT
 * Ejecutar desde la línea de comandos: php scripts/test_auth.php
 */

// Configuración
$baseUrl = 'http://localhost:8000/api';
$testEmail = 'admin@ejemplo.com'; // Cambiar por un email válido
$testPassword = 'admin123'; // Cambiar por una contraseña válida

echo "=== PRUEBA DE AUTENTICACIÓN JWT ===\n\n";

// 1. Prueba de Login
echo "1. Probando Login...\n";
$loginData = json_encode([
    'email' => $testEmail,
    'password' => $testPassword
]);

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $baseUrl . '/login');
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $loginData);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'Accept: application/json'
]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo "Código de respuesta: $httpCode\n";
echo "Respuesta: " . $response . "\n\n";

if ($httpCode === 200) {
    $loginResult = json_decode($response, true);
    $token = $loginResult['token'] ?? null;
    
    if ($token) {
        echo "✅ Login exitoso! Token obtenido.\n\n";
        
        // 2. Prueba de API protegida (listar usuarios)
        echo "2. Probando API protegida (listar usuarios)...\n";
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $baseUrl . '/usuarios');
        curl_setopt($ch, CURLOPT_HTTPGET, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Authorization: Bearer ' . $token,
            'Accept: application/json'
        ]);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        echo "Código de respuesta: $httpCode\n";
        echo "Respuesta: " . $response . "\n\n";
        
        if ($httpCode === 200) {
            echo "✅ API protegida accesible con token!\n\n";
        } else {
            echo "❌ Error al acceder a API protegida\n\n";
        }
        
        // 3. Prueba de API con rol específico (crear usuario - solo ADMIN)
        echo "3. Probando API con rol ADMIN (crear usuario)...\n";
        
        $userData = json_encode([
            'nombre_usuario' => 'test_user_' . time(),
            'nombre' => 'Test',
            'nombre2' => '',
            'apellido1' => 'User',
            'apellido2' => '',
            'password' => '123456',
            'email' => 'test' . time() . '@ejemplo.com',
            'telefono' => '123456',
            'departamento' => 'IT',
            'estado' => 'ACTIVO',
            'roles' => [1] // Asumiendo que 1 es ADMIN
        ]);
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $baseUrl . '/usuarios');
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $userData);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Authorization: Bearer ' . $token,
            'Content-Type: application/json',
            'Accept: application/json'
        ]);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        echo "Código de respuesta: $httpCode\n";
        echo "Respuesta: " . $response . "\n\n";
        
        if ($httpCode === 201) {
            echo "✅ Usuario creado exitosamente (rol ADMIN confirmado)!\n\n";
        } elseif ($httpCode === 403) {
            echo "⚠️ Acceso denegado - Usuario no tiene rol ADMIN\n\n";
        } else {
            echo "❌ Error al crear usuario\n\n";
        }
        
        // 4. Prueba de Logout
        echo "4. Probando Logout...\n";
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $baseUrl . '/logout');
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Authorization: Bearer ' . $token,
            'Accept: application/json'
        ]);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        echo "Código de respuesta: $httpCode\n";
        echo "Respuesta: " . $response . "\n\n";
        
        if ($httpCode === 200) {
            echo "✅ Logout exitoso!\n\n";
        } else {
            echo "❌ Error en logout\n\n";
        }
        
    } else {
        echo "❌ Token no encontrado en la respuesta\n\n";
    }
    
} else {
    echo "❌ Login falló\n\n";
}

echo "=== FIN DE PRUEBAS ===\n";
echo "\nPara ejecutar este script:\n";
echo "1. Asegúrate de que el servidor Laravel esté corriendo\n";
echo "2. Modifica las credenciales de prueba en este script\n";
echo "3. Ejecuta: php scripts/test_auth.php\n";
