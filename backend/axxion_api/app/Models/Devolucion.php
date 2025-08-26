<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Devolucion extends Model
{
    use HasFactory;

    protected $table = 'devolucion';

    protected $fillable = [
        'renta_id',
        'fecha_devolucion_programada',
        'fecha_devolucion_real',
        'estado_devolucion',
        'persona_recibe',
        'notas_generales',
    ];

    public function renta()
    {
        return $this->belongsTo(Renta::class);
    }
}
