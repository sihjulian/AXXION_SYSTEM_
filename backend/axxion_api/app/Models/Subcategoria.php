<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Subcategoria extends Model
{
    use HasFactory;

    protected $table = 'subcategoria';

    protected $fillable = [
        'nombre',
        'descripcion',
    ];

    public function categorias()
    {
        return $this->belongsToMany(Categoria::class, 'categoria_subcategoria');
    }

    public function productos()
    {
        return $this->belongsToMany(Producto::class, 'producto_subcategoria');
    }
}
