function Get-SystemUsers {

    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        Write-Host "ADVERTENCIA: Ejecute como Administrador para obtener informacion completa." -ForegroundColor Yellow
        Write-Host ""
    }

    try {
        $users = Get-LocalUser | Where-Object { $_.Enabled -eq $true }
        $result = @()

        Write-Host "Obteniendo eventos de inicio de sesion..." -ForegroundColor Gray
        $allLoginEvents = @()
        try {
            $allLoginEvents = Get-WinEvent -FilterHashtable @{
                LogName = 'Security'
                ID = 4624
            } -MaxEvents 20000 -ErrorAction Stop
        }
        catch {
            Write-Host "No se pudieron obtener eventos de seguridad. Usando metodos alternativos." -ForegroundColor Yellow
        }

        foreach ($u in $users) {
            $lastLogon = "Nunca"
            $loginType = ""
            
            if ($allLoginEvents.Count -gt 0) {
                $userLoginEvents = $allLoginEvents | Where-Object {
                    $targetUser = $_.Properties[5].Value
                    $logonTypeValue = $_.Properties[8].Value
                    
                    $nameMatch = ($targetUser -eq $u.Name) -or 
                                 ($targetUser -like "*$($u.Name)*") -or
                                 ($u.FullName -and $targetUser -eq $u.FullName)
                    
                    $validLogonType = ($logonTypeValue -in @(2, 7, 10, 11))
                    
                    $nameMatch -and $validLogonType
                }
                
                if ($userLoginEvents.Count -gt 0) {
                    $mostRecent = $userLoginEvents | Sort-Object TimeCreated -Descending | Select-Object -First 1
                    $lastLogon = $mostRecent.TimeCreated
                    
                    $logonTypeValue = $mostRecent.Properties[8].Value
                    $loginType = switch ($logonTypeValue) {
                        2 { "Login local" }
                        7 { "Desbloqueo" }
                        10 { "Escritorio remoto" }
                        11 { "Login con cache" }
                        default { "Tipo $logonTypeValue" }
                    }
                }
            }
            
            if ($lastLogon -eq "Nunca" -and $u.LastLogon) {
                $lastLogon = $u.LastLogon
                $loginType = "Registro local"
            }
            
            if ($lastLogon -eq "Nunca") {
                try {
                    $quser = query user 2>$null
                    if ($quser -match $u.Name) {
                        $lastLogon = "Sesion activa"
                        $loginType = "Conectado ahora"
                    }
                }
                catch {}
            }

            $result += [PSCustomObject]@{
                Usuario     = $u.Name
                UltimoLogin = $lastLogon
                Tipo        = $loginType
            }
        }

        $result | Sort-Object @{Expression={
            if ($_.UltimoLogin -eq "Nunca") { [DateTime]::MinValue }
            elseif ($_.UltimoLogin -eq "Sesion activa") { [DateTime]::Now }
            else { $_.UltimoLogin }
        }; Descending=$true} | Format-Table -AutoSize
        
        Write-Host ""
        Write-Host "Tipos de login:" -ForegroundColor Cyan
        Write-Host "  - Login local: Inicio de sesion con teclado/mouse fisico" -ForegroundColor Gray
        Write-Host "  - Desbloqueo: Desbloqueo de pantalla (implica sesion activa)" -ForegroundColor Gray
        Write-Host "  - Login con cache: Login usando credenciales guardadas" -ForegroundColor Gray
        Write-Host "  - Escritorio remoto: Conexion RDP" -ForegroundColor Gray
    }
    catch {
        Write-Host "Error al listar usuarios: $_" -ForegroundColor Red
    }
}