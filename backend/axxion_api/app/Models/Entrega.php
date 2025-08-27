<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Entrega extends Model
{
    use HasFactory;

    protected $table = 'entrega';

    protected $fillable = [
        'renta_id',
        'direccion_id',
        'fecha_envio',
        'compania_envio',
        'numero_guia',
        'estado_entrega',
        'notas',
    ];

    public function renta()
    {
        return $this->belongsTo(Renta::class);
    }

    public function direccion()
    {
        return $this->belongsTo(Direccion::class);
    }
}
