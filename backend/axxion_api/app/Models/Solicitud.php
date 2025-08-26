<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Solicitud extends Model
{
    use HasFactory;

    protected $table = 'solicitud';

    protected $fillable = [
        'cliente_id',
        'fecha_solicitud',
        'nombre_producto_alternativo',
        'cantidad_solicitada',
        'descripcion_necesidad',
        'estado_solicitud',
    ];

    public function cliente()
    {
        return $this->belongsTo(Cliente::class);
    }

    public function productos()
    {
        return $this->belongsToMany(Producto::class, 'solicitud_producto');
    }

    public function cotizaciones()
    {
        return $this->hasMany(Cotizacion::class);
    }
}
