<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ChamberEvent extends Model
{
    protected $fillable = [
        'title',
        'type',
        'event_date',
        'description',
        'image_url',
        'external_link',
    ];
}
