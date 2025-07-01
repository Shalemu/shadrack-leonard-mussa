<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Childrens extends Model
{
     use HasFactory;
     
    protected $table = 'childrens';

    protected $fillable = [
    'name',
    'dob',
    'gender',
    'class_level',
    'street',
    'phone',
    'guardian_name',
    'email',
    'school',
    'baptized',
];
   

}
