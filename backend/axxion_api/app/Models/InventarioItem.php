<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class InventarioItem extends Model
{
    use HasFactory;

    protected $table = 'inventario_item';

    protected $fillable = [
        'producto_id',
        'numero_serie',
        'estado_item',
        'fecha_adquisicion',
        'costo_adquisicion',
        'ubicacion_fisica',
        'notas',
    ];

    public function producto()
    {
        return $this->belongsTo(Producto::class);
    }

    public function mantenimientos()
    {
        return $this->hasMany(Mantenimiento::class);
    }

    public function rentas()
    {
        return $this->belongsToMany(Renta::class, 'renta_inventario_item')
            ->withPivot('precio_renta_item', 'condicion_salida', 'condicion_regreso', 'notas');
    }
}
