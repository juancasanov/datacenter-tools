function Get-MemoryUsage {
    Write-Host ""
    Write-Host "Informacion de memoria del sistema:" -ForegroundColor Cyan
    Write-Host ""

    try {
        $os = Get-CimInstance Win32_OperatingSystem
        
        $memTotalGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
        $memFreeGB = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
        $memUsedGB = $memTotalGB - $memFreeGB
        $memUsedPercent = [math]::Round(($memUsedGB / $memTotalGB) * 100, 2)

        $pageFiles = Get-CimInstance Win32_PageFileUsage
        
        if ($pageFiles) {
            $swapTotalMB = ($pageFiles | Measure-Object -Property AllocatedBaseSize -Sum).Sum
            $swapUsedMB = ($pageFiles | Measure-Object -Property CurrentUsage -Sum).Sum
            $swapTotalGB = [math]::Round($swapTotalMB / 1024, 2)
            $swapUsedGB = [math]::Round($swapUsedMB / 1024, 2)
            $swapFreeGB = $swapTotalGB - $swapUsedGB
            $swapUsedPercent = if ($swapTotalGB -gt 0) {
                [math]::Round(($swapUsedGB / $swapTotalGB) * 100, 2)
            } else {
                0
            }
        } else {
            $swapTotalGB = 0
            $swapUsedGB = 0
            $swapFreeGB = 0
            $swapUsedPercent = 0
        }

        Write-Host "Memoria Fisica:" -ForegroundColor Yellow
        [PSCustomObject]@{
            "Total (GB)"    = $memTotalGB
            "Usada (GB)"    = $memUsedGB
            "Libre (GB)"    = $memFreeGB
            "Uso (%)"       = "$memUsedPercent%"
        } | Format-Table -AutoSize

        Write-Host "Archivo de Paginacion (Swap):" -ForegroundColor Yellow
        [PSCustomObject]@{
            "Total (GB)"    = $swapTotalGB
            "Usado (GB)"    = $swapUsedGB
            "Libre (GB)"    = $swapFreeGB
            "Uso (%)"       = "$swapUsedPercent%"
        } | Format-Table -AutoSize

        if ($pageFiles) {
            Write-Host "Archivos de Paginacion:" -ForegroundColor Yellow
            $pageFiles | Select-Object Name, 
                @{Name="Tamano Asignado (MB)";Expression={$_.AllocatedBaseSize}},
                @{Name="Uso Actual (MB)";Expression={$_.CurrentUsage}} |
                Format-Table -AutoSize
        } else {
            Write-Host "No hay archivos de paginacion configurados." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Error al obtener informacion de memoria: $_" -ForegroundColor Red
    }
}