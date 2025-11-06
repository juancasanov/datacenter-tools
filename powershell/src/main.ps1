# main.ps1
# ------------------------------------------------------------
# Herramienta de administración de Data Center - PowerShell
# Fecha: 2025-11-06
# ------------------------------------------------------------

# Evita salida innecesaria
$ErrorActionPreference = "Stop"
Clear-Host

function Show-Menu {
    Clear-Host
    Write-Host "==========================================="
    Write-Host " Herramienta de Administracion - PowerShell"
    Write-Host "==========================================="
    Write-Host "1. Mostrar usuarios y ultimo ingreso"
    Write-Host "2. Mostrar filesystems y espacio disponible"
    Write-Host "3. Mostrar los 10 archivos mas grandes de un disco"
    Write-Host "4. Mostrar memoria libre y swap en uso"
    Write-Host "5. Realizar copia de seguridad a memoria USB"
    Write-Host "6. Salir"
    Write-Host "-------------------------------------------"
}

do {
    Show-Menu
    $option = Read-Host "Seleccione una opcion [1-6]"

    switch ($option) {
        1 { Write-Host ">> Ejecutando modulo: Usuarios..." }
        2 { Write-Host ">> Ejecutando modulo: Filesystems..." }
        3 { Write-Host ">> Ejecutando modulo: Archivos grandes..." }
        4 { Write-Host ">> Ejecutando modulo: Memoria y swap..." }
        5 { Write-Host ">> Ejecutando modulo: Backup..." }
        6 { Write-Host "Saliendo del programa..."; break }
        default { Write-Host "Opcion invalida. Intente nuevamente."; Start-Sleep -Seconds 1 }
    }

    if ($option -ne 6) {
        Write-Host "`nPresione Enter para volver al menu..."
        Read-Host
    }

} while ($option -ne 6)
