# Datacenter Tools – PowerShell

Herramienta administrativa desarrollada en **PowerShell** para automatizar tareas comunes de gestión en un Data Center sobre sistemas **Windows**.  
Permite consultar usuarios, discos, archivos grandes, memoria y realizar copias de seguridad hacia unidades externas (USB).

---

## Funcionalidades

| Opción | Descripción |
|--------|--------------|
| **1. Usuarios** | Muestra los usuarios locales y la fecha/hora de su último ingreso. |
| **2. Filesystems o discos** | Lista los discos conectados, tamaño total y espacio libre. |
| **3. Archivos grandes** | Despliega los 10 archivos más grandes en un disco especificado. |
| **4. Memoria y swap** | Informa la memoria libre y espacio de paginación (swap). |
| **5. Copia de seguridad (backup)** | Copia un directorio especificado a una memoria USB, con un catálogo CSV. |
| **6. Salir** | Termina la ejecución del script. |

---

## Estructura del módulo PowerShell

````
powershell/
├── src/
│ ├── main.ps1 
│ ├── modules/
│ │ ├── users.ps1 
│ │ ├── disks.ps1 
│ │ ├── files.ps1 
│ │ ├── memory.ps1
│ │ ├── backup.ps1 
│
├── tests/ 
└── README.md
````
---

## Ejecución

1. Abre PowerShell como **Administrador**.  
2. Navega hasta el directorio del proyecto:

   ```powershell
   cd powershell/src
   ```

3. Permite ejecución temporal de scripts locales:

    ````Powershell
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
    ````

4. Ejecuta el programa:

    ````Powershell
    .\main.ps1
    ````