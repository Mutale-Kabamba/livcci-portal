<?php

namespace App\Services;

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

class BusinessProfileFileService
{
    private const LOGO_DISK = 'public';
    private const LOGO_PATH = 'logos';

    /**
     * Store a logo file and return the storage URL.
     */
    public function storeLogo(UploadedFile $file): string
    {
        try {
            $path = $file->store(self::LOGO_PATH, self::LOGO_DISK);
            return '/storage/' . $path;
        } catch (\Exception $e) {
            \Log::error('Failed to store logo file: ' . $e->getMessage());
            throw new \RuntimeException('Failed to upload logo file. Please try again.');
        }
    }

    /**
     * Delete an existing logo file by URL.
     */
    public function deleteLogo(?string $logoUrl): bool
    {
        if (!$logoUrl) {
            return true;
        }

        try {
            $path = (string) $logoUrl;
            $path = str_replace('/storage/', '', $path);
            $path = str_replace('storage/', '', $path);
            $path = ltrim($path, '/');
            
            if (Storage::disk(self::LOGO_DISK)->exists($path)) {
                return Storage::disk(self::LOGO_DISK)->delete($path);
            }
            
            // File doesn't exist but that's okay, consider it deleted
            return true;
        } catch (\Exception $e) {
            \Log::warning('Failed to delete logo file: ' . $e->getMessage());
            // Don't throw exception for delete failures, just log
            return true;
        }
    }

    /**
     * Replace an existing logo with a new one.
     */
    public function replaceLogo(UploadedFile $newFile, ?string $oldLogoUrl): string
    {
        // Delete old logo first
        $this->deleteLogo($oldLogoUrl);

        // Store new logo
        return $this->storeLogo($newFile);
    }
}
