<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Direccion extends Model
{
    use HasFactory;

    protected $table = 'direccion';

    protected $fillable = [
        'calle',
        'numero_exterior',
        'numero_interior',
        'colonia',
        'ciudad',
        'estado_provincia',
        'codigo_postal',
        'pais',
        'referencias',
    ];

    public function clientes()
    {
        return $this->belongsToMany(Cliente::class, 'cliente_direccion');
    }

    public function proveedores()
    {
        return $this->belongsToMany(Proveedor::class, 'proveedor_direccion');
    }

    public function entregas()
    {
        return $this->hasMany(Entrega::class);
    }
}
