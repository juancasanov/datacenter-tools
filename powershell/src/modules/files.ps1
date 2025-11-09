function Get-LargestFiles {
    $drive = Read-Host "Ingrese la ruta del disco o carpeta (ej: C:\ o C:\Users)"
    
    if (-not (Test-Path $drive)) {
        Write-Host "Ruta no valida." -ForegroundColor Red
        return
    }

    Write-Host ""
    Write-Host "Buscando los 10 archivos mas grandes en $drive..." -ForegroundColor Yellow
    Write-Host "Esto puede tardar varios minutos dependiendo del tamano..." -ForegroundColor Yellow
    Write-Host ""

    try {
        $archivos = Get-ChildItem -Path $drive -Recurse -File -ErrorAction SilentlyContinue |
            Sort-Object Length -Descending |
            Select-Object -First 10

        if ($archivos.Count -eq 0) {
            Write-Host "No se encontraron archivos en la ruta especificada." -ForegroundColor Yellow
            return
        }

        $archivos | Select-Object `
            @{Name="Ruta";Expression={$_.FullName}}, 
            @{Name="Tamano (MB)";Expression={[math]::Round($_.Length / 1MB, 2)}},
            @{Name="Ultima modificacion";Expression={$_.LastWriteTime}} |
            Format-Table -AutoSize -Wrap

        Write-Host "Busqueda completada." -ForegroundColor Green
    }
    catch {
        Write-Host "Error al listar archivos: $_" -ForegroundColor Red
    }
}