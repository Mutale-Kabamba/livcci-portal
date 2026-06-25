<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ChamberEvent extends Model
{
    protected $fillable = [
        'title',
        'type',
        'event_date',
        'event_end_date',
        'description',
        'image_url',
        'external_link',
    ];

    protected $casts = [
        'event_date' => 'date',
        'event_end_date' => 'date',
    ];
}
