Clear-Host
Write-Host "==============================="
Write-Host " DATACENTER TOOLS (PowerShell)"
Write-Host "==============================="

# Ruta base del proyecto
$BasePath = Split-Path -Parent $MyInvocation.MyCommand.Path
$ModulesPath = Join-Path $BasePath "modules"

$modules = @("users.ps1", "disks.ps1", "files.ps1", "memory.ps1", "backup.ps1")
$loadedModules = @()

foreach ($module in $modules) {
    $path = Join-Path $ModulesPath $module
    if (Test-Path $path) {
        try {
            . $path
            $loadedModules += $module
            Write-Host "Modulo cargado: $module" -ForegroundColor Green
        }
        catch {
            Write-Host "Error al cargar $module : $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Modulo no encontrado: $module" -ForegroundColor Yellow
    }
}

Start-Sleep -Seconds 2

function Show-Menu {
    Clear-Host
    Write-Host "==============================="
    Write-Host "        Menu Principal"
    Write-Host "==============================="
    Write-Host "1. Listar usuarios y ultimo login"
    Write-Host "2. Listar discos conectados y espacio libre"
    Write-Host "3. Mostrar 10 archivos mas grandes de un disco"
    Write-Host "4. Mostrar memoria libre y espacio de paginacion (swap)"
    Write-Host "5. Realizar copia de seguridad a memoria USB"
    Write-Host "6. Salir"
    Write-Host ""
}

do {
    Show-Menu
    $opcion = Read-Host "Seleccione una opcion (1-6)"

    switch ($opcion) {
        1 { 
            if (Get-Command Get-SystemUsers -ErrorAction SilentlyContinue) {
                Get-SystemUsers 
            } else {
                Write-Host "Funcion no disponible. Verifica el modulo users.ps1" -ForegroundColor Red
            }
        }
        2 { 
            if (Get-Command Get-DisksInfo -ErrorAction SilentlyContinue) {
                Get-DisksInfo 
            } else {
                Write-Host "Funcion no disponible. Verifica el modulo disks.ps1" -ForegroundColor Red
            }
        }
        3 { 
            if (Get-Command Get-LargestFiles -ErrorAction SilentlyContinue) {
                Get-LargestFiles 
            } else {
                Write-Host "Funcion no disponible. Verifica el modulo files.ps1" -ForegroundColor Red
            }
        }
        4 { 
            if (Get-Command Get-MemoryUsage -ErrorAction SilentlyContinue) {
                Get-MemoryUsage 
            } else {
                Write-Host "Funcion no disponible. Verifica el modulo memory.ps1" -ForegroundColor Red
            }
        }
        5 { 
            if (Get-Command Start-BackupProcess -ErrorAction SilentlyContinue) {
                Start-BackupProcess 
            } else {
                Write-Host "Funcion no disponible. Verifica el modulo backup.ps1" -ForegroundColor Red
            }
        }
        6 { Write-Host "`nSaliendo del sistema..."; break }
        Default { Write-Host "Opcion no valida, intente de nuevo." -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }

    if ($opcion -ne 6) {
        Write-Host "`nPresione cualquier tecla para continuar..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }

} while ($opcion -ne 6)