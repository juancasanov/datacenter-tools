function Start-BackupProcess {
    Write-Host ""
    Write-Host "Proceso de Copia de Seguridad" -ForegroundColor Cyan
    Write-Host "==============================" -ForegroundColor Cyan
    Write-Host ""

    $source = Read-Host "Ingrese la ruta del directorio a respaldar"
    
    if (-not (Test-Path $source)) {
        Write-Host "Ruta origen no valida o no existe." -ForegroundColor Red
        return
    }

    Write-Host ""
    Write-Host "Discos extraibles disponibles:" -ForegroundColor Yellow
    $usbDrives = Get-CimInstance Win32_LogicalDisk | 
        Where-Object { $_.DriveType -eq 2 } |
        Select-Object DeviceID, 
            @{Name="Tamano (GB)";Expression={[math]::Round($_.Size / 1GB, 2)}},
            @{Name="Libre (GB)";Expression={[math]::Round($_.FreeSpace / 1GB, 2)}}

    if ($usbDrives) {
        $usbDrives | Format-Table -AutoSize
    } else {
        Write-Host "No se detectaron unidades USB extraibles." -ForegroundColor Yellow
    }

    $usb = Read-Host "Ingrese la letra de unidad USB (ej: E:\)"
    
    if (-not (Test-Path $usb)) {
        Write-Host "Unidad USB no encontrada." -ForegroundColor Red
        return
    }

    $usbInfo = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DeviceID -eq $usb.TrimEnd('\') }
    $sourceSize = (Get-ChildItem -Path $source -Recurse -ErrorAction SilentlyContinue | 
        Measure-Object -Property Length -Sum).Sum
    
    $sourceSizeGB = [math]::Round($sourceSize / 1GB, 2)
    $usbFreeGB = [math]::Round($usbInfo.FreeSpace / 1GB, 2)

    Write-Host ""
    Write-Host "Espacio requerido: $sourceSizeGB GB" -ForegroundColor Yellow
    Write-Host "Espacio disponible: $usbFreeGB GB" -ForegroundColor Yellow

    if ($sourceSize -gt $usbInfo.FreeSpace) {
        Write-Host "No hay suficiente espacio en la unidad USB." -ForegroundColor Red
        return
    }

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupDir = Join-Path $usb ("backup_" + $timestamp)
    
    try {
        New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
        Write-Host ""
        Write-Host "Directorio de backup creado: $backupDir" -ForegroundColor Green
    }
    catch {
        Write-Host "Error al crear directorio de backup: $_" -ForegroundColor Red
        return
    }

    Write-Host ""
    Write-Host "Iniciando copia de seguridad..." -ForegroundColor Cyan
    Write-Host "Esto puede tardar varios minutos..." -ForegroundColor Yellow
    Write-Host ""

    try {
        $files = Get-ChildItem -Path $source -Recurse -File -ErrorAction SilentlyContinue
        $totalFiles = $files.Count
        $currentFile = 0

        foreach ($file in $files) {
            $currentFile++
            $percentComplete = [math]::Round(($currentFile / $totalFiles) * 100, 2)
            
            Write-Progress -Activity "Copiando archivos" -Status "$currentFile de $totalFiles archivos ($percentComplete%)" -PercentComplete $percentComplete

            $relativePath = $file.FullName.Substring($source.Length)
            $destPath = Join-Path $backupDir $relativePath
            $destFolder = Split-Path $destPath -Parent

            if (-not (Test-Path $destFolder)) {
                New-Item -ItemType Directory -Force -Path $destFolder | Out-Null
            }

            Copy-Item -Path $file.FullName -Destination $destPath -Force
        }

        Write-Progress -Activity "Copiando archivos" -Completed

        Write-Host ""
        Write-Host "Generando catalogo de archivos..." -ForegroundColor Yellow
        $catalogFile = Join-Path $backupDir "catalogo.csv"
        
        Get-ChildItem -Path $backupDir -Recurse -File |
            Where-Object { $_.Name -ne "catalogo.csv" } |
            Select-Object `
                @{Name="Ruta Relativa";Expression={$_.FullName.Substring($backupDir.Length)}},
                @{Name="Tamano (bytes)";Expression={$_.Length}},
                @{Name="Tamano (MB)";Expression={[math]::Round($_.Length / 1MB, 2)}},
                @{Name="Fecha Modificacion";Expression={$_.LastWriteTime}},
                @{Name="Fecha Creacion";Expression={$_.CreationTime}} |
            Export-Csv -Path $catalogFile -NoTypeInformation -Encoding UTF8

        Write-Host ""
        Write-Host "Backup completado exitosamente!" -ForegroundColor Green
        Write-Host "Ubicacion: $backupDir" -ForegroundColor Cyan
        Write-Host "Catalogo generado: $catalogFile" -ForegroundColor Cyan
        Write-Host "Total de archivos respaldados: $totalFiles" -ForegroundColor Cyan
    }
    catch {
        Write-Host "Error durante el backup: $_" -ForegroundColor Red
    }
}