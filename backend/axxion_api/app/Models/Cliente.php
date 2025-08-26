<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cliente extends Model
{
    use HasFactory;

    protected $table = 'cliente';

    protected $fillable = [
        'nombre',
        'nombre2',
        'apellido1',
        'apellido2',
        'rfc',
        'telefono_principal',
        'correo_electronico',
        'tipo_cliente',
        'estado_cliente',
    ];

    public function direcciones()
    {
        return $this->belongsToMany(Direccion::class, 'cliente_direccion')->withPivot('es_principal');
    }

    public function solicitudes()
    {
        return $this->hasMany(Solicitud::class);
    }

    public function cotizaciones()
    {
        return $this->hasMany(Cotizacion::class);
    }

    public function rentas()
    {
        return $this->hasMany(Renta::class);
    }
}
