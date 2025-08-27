<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Proveedor extends Model
{
    use HasFactory;

    protected $table = 'proveedor';

    protected $fillable = [
        'nombre_empresa',
        'rfc',
        'nombre_contacto',
        'telefono_contacto',
        'correo_contacto',
        'estado_proveedor',
    ];

    public function direcciones()
    {
        return $this->belongsToMany(Direccion::class, 'proveedor_direccion')->withPivot('es_principal');
    }
}
