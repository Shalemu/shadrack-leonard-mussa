<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class product extends Model
{
   protected $table = 'product';

   protected $fillable =[
    'name',
    'price',
    'description',
    'status',
    'image',
    'category_id',
    
   ];


   public function category()
{
    return $this->belongsTo(Category::class);
}

}
