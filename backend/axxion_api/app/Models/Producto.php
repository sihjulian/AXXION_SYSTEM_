<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Producto extends Model
{
    use HasFactory;

    protected $table = 'producto';

    protected $fillable = [
        'nombre',
        'descripcion',
        'marca',
        'modelo',
        'precio_referencia_renta',
        'sku',
    ];

    public function subcategorias()
    {
        return $this->belongsToMany(Subcategoria::class, 'producto_subcategoria');
    }

    public function inventarioItems()
    {
        return $this->hasMany(InventarioItem::class);
    }

    public function solicitudes()
    {
        return $this->belongsToMany(Solicitud::class, 'solicitud_producto');
    }

    public function detallesCotizacion()
    {
        return $this->hasMany(DetalleCotizacion::class);
    }
}
