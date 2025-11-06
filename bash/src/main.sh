#!/bin/bash
# ------------------------------------------------------------
# Herramienta de administración de Data Center - Bash
# Fecha: 2025-11-06
# ------------------------------------------------------------

clear

show_menu() {
  clear
  echo "==========================================="
  echo "  Herramienta de Administracion - Bash"
  echo "==========================================="
  echo "1. Mostrar usuarios y ultimo ingreso"
  echo "2. Mostrar filesystems y espacio disponible"
  echo "3. Mostrar los 10 archivos más grandes de un disco"
  echo "4. Mostrar memoria libre y swap en uso"
  echo "5. Realizar copia de seguridad a memoria USB"
  echo "6. Salir"
  echo "-------------------------------------------"
}

while true; do
  show_menu
  read -p "Seleccione una opcion [1-6]: " option

  case $option in
    1) echo ">> Ejecutando modulo: Usuarios..." ;;
    2) echo ">> Ejecutando modulo: Filesystems..." ;;
    3) echo ">> Ejecutando modulo: Archivos grandes..." ;;
    4) echo ">> Ejecutando modulo: Memoria y swap..." ;;
    5) echo ">> Ejecutando modulo: Backup..." ;;
    6) echo "Saliendo del programa..."; exit 0 ;;
    *) echo "Opcion invalida. Intente nuevamente." ;;
  esac

  echo
  read -p "Presione Enter para volver al menu..."
done
