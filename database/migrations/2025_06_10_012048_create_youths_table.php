<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
 public function up()
{
    Schema::create('youths', function (Blueprint $table) {
        $table->id();
        $table->string('name');
        $table->string('street');
        $table->string('gender');
        $table->string('marital_status');
        $table->string('email')->nullable();
        $table->string('phone');
        $table->date('dob');
        $table->timestamps();
    });
}


    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('youths');
    }
};
