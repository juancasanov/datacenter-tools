# Datacenter Tools
Herramientas administrativas para centros de datos, desarrolladas en PowerShell y Bash.

## Descripción
Este proyecto implementa dos utilidades de línea de comandos, una en PowerShell y otra en Bash, que permiten automatizar tareas frecuentes de administración de sistemas en un data center. El objetivo es facilitar la gestión de usuarios, disco, memoria, archivos grandes y backups, siguiendo un menú interactivo.

## Funcionalidades

1. Cada herramienta (PowerShell y Bash) incluye:
2. Listado de usuarios y fecha/hora de último acceso.
3. Información de discos y filesystems: tamaño total y espacio libre.
4. Lista de los diez archivos más grandes en una ruta específica.
5. Estado de memoria libre y swap en uso.
6. Backup de un directorio a una USB, con catálogo de archivos y fecha de modificación.

## Estrucutra del Proyecto
```
/datacenter-tools/
├── powershell/
├── src/
│ ├── main.ps1 # Script principal con el menú
│ ├── modules/
│ │ ├── users.ps1 # Módulo para listar usuarios
│ │ ├── disks.ps1 # Módulo para listar discos
│ │ ├── files.ps1 # Módulo para listar archivos grandes
│ │ ├── memory.ps1 # Módulo para información de memoria
│ │ ├── backup.ps1 # Módulo para backup
├── tests/ 
└── README.md  
bash/
├── src/
│ ├── main.sh # Script principal con el menú
│ ├── modules/
│ │ ├── users.sh # Módulo para listar usuarios
│ │ ├── disks.sh # Módulo para listar filesystems
│ │ ├── files.sh # Módulo para archivos grandes
│ │ ├── memory.sh # Módulo para memoria/swap
│ │ ├── backup.sh # Módulo para backup
├── tests/ # Scripts o pruebas unitarias
└── README.md 
├── docs/             
├── .gitignore
├── README.md         
```

## Instalación y Uso
1. Clona el repositorio:

    ``https://github.com/juancasanov/datacenter-tools.git``

2. Ingresa en la carpeta de la herramienta que usarás:

    ``cd datacenter-tools/powershell/src``

    o

    ``cd datacenter-tools/bash/src``

3. Lee el README específico y sigue las instrucciones para ejecutar el menú.

## Colaboradores
- Ángela María Gonzales
- Juan Manuel Casanova
- Juliana Filigrana