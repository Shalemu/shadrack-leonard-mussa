<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductResources extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        // return parent::toArray($request);

        return [
            'id'=>$this->id,
            'Product_name' => $this->name,
            'description' => $this->description,
            'price'=>$this->price,
            'image_url'   => $this->image ? asset('storage/'.$this->image) : null,
            'category'    => $this->category ? $this->category->name : null,
            'created_at'=>$this->created_at
        ];
    }
}
