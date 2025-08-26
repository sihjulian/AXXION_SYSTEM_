<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cotizacion extends Model
{
    use HasFactory;

    protected $table = 'cotizacion';

    protected $fillable = [
        'cliente_id',
        'solicitud_id',
        'fecha_cotizacion',
        'fecha_validez',
        'monto_total',
        'estado_cotizacion',
        'terminos_condiciones',
        'notas_internas',
    ];

    public function cliente()
    {
        return $this->belongsTo(Cliente::class);
    }

    public function solicitud()
    {
        return $this->belongsTo(Solicitud::class);
    }

    public function detalles()
    {
        return $this->hasMany(DetalleCotizacion::class);
    }

    public function renta()
    {
        return $this->hasOne(Renta::class);
    }
}
