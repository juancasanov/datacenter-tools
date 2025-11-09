function Get-DisksInfo {
    Write-Host "`nDiscos conectados al sistema:`n" -ForegroundColor Cyan

    try {
        Get-CimInstance Win32_LogicalDisk | Where-Object { $_.Size -gt 0 } | ForEach-Object {
            $tipo = switch ($_.DriveType) {
                2 { "Extraible" }
                3 { "Disco Local" }
                4 { "Red" }
                5 { "CD-ROM" }
                Default { "Desconocido" }
            }

            $tamanioGB = if ($_.Size) { [math]::Round($_.Size / 1GB, 2) } else { 0 }
            $libreGB = if ($_.FreeSpace) { [math]::Round($_.FreeSpace / 1GB, 2) } else { 0 }
            $usadoGB = $tamanioGB - $libreGB
            $porcentajeLibre = if ($tamanioGB -gt 0) { 
                [math]::Round(($libreGB / $tamanioGB) * 100, 2) 
            } else { 
                0 
            }

            [PSCustomObject]@{
                Unidad          = $_.DeviceID
                Tipo            = $tipo
                'Tamaño (GB)'   = $tamanioGB
                'Usado (GB)'    = $usadoGB
                'Libre (GB)'    = $libreGB
                'Libre (%)'     = "$porcentajeLibre%"
            }
        } | Format-Table -AutoSize
    }
    catch {
        Write-Host "Error al obtener información de discos: $_" -ForegroundColor Red
    }
}