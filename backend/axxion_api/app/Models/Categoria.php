<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Categoria extends Model
{
    use HasFactory;

    protected $table = 'categoria';

    protected $fillable = [
        'nombre',
        'descripcion',
        'tipo_categoria',
    ];

    public function subcategorias()
    {
        return $this->belongsToMany(Subcategoria::class, 'categoria_subcategoria');
    }
}
