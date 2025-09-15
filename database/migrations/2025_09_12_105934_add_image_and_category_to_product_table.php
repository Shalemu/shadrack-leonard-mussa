<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('product', function (Blueprint $table) {
            $table->string('image')->nullable()->after('status'); // new image field
            $table->unsignedBigInteger('category_id')->nullable()->after('image'); // foreign key

            // foreign key reference
            $table->foreign('category_id')
                  ->references('id')->on('categories')
                  ->onDelete('set null');
        });
    }

    public function down(): void
    {
        Schema::table('product', function (Blueprint $table) {
            $table->dropForeign(['category_id']);
            $table->dropColumn(['image', 'category_id']);
        });
    }
};

