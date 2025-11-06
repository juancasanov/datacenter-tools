
# Datacenter Tools – Bash

Herramienta administrativa desarrollada en **Bash** para automatizar tareas de gestión en un Data Center sobre sistemas **Linux**.  
Permite listar usuarios, monitorear discos, revisar archivos grandes, consultar uso de memoria y realizar copias de seguridad hacia dispositivos USB.

---

## Funcionalidades

| Opción | Descripción |
|--------|--------------|
| **1. Usuarios** | Lista los usuarios del sistema y la fecha de su último login. |
| **2. Filesystems o discos** | Muestra los discos montados, su tamaño y espacio libre. |
| **3. Archivos grandes** | Muestra los 10 archivos más grandes dentro de un filesystem especificado. |
| **4. Memoria y swap** | Reporta memoria libre y swap utilizada (en bytes y porcentaje). |
| **5. Copia de seguridad (backup)** | Copia un directorio a una memoria USB, incluyendo un catálogo de archivos. |
| **6. Salir** | Termina la ejecución del programa. |

---

## Estructura del módulo Bash

````
bash/
├── src/
│ ├── main.sh # Script principal con el menú
│ ├── modules/
│ │ ├── users.sh 
│ │ ├── disks.sh 
│ │ ├── files.sh
│ │ ├── memory.sh 
│ │ ├── backup.sh 
│
├── tests/ 
└── README.md
````


---

## Ejecución

1. Abre una terminal Linux o WSL.
2. Accede al directorio de los scripts:

   ```bash
   cd bash/src
3. Asegúrate de tener permisos de ejecución:
chmod +x main.sh
4. Ejecuta el menú principal:

    ```bash
    ./main.sh
    ````