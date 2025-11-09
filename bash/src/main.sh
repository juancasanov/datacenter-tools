#!/usr/bin/env bash
# main.sh - Menú principal para Datacenter Tools (Bash)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

for mod in users.sh disks.sh files.sh memory.sh backup.sh; do
  if [[ -f "$MODULES_DIR/$mod" ]]; then
    source "$MODULES_DIR/$mod"
  else
    echo "ERROR: Módulo faltante: $MODULES_DIR/$mod"
    exit 1
  fi
done

show_menu() {
  clear
  cat <<EOF
===========================================
  🖥️  Herramienta de Administración - Bash
===========================================
1. Mostrar usuarios y último ingreso
2. Mostrar filesystems y espacio disponible
3. Mostrar los 10 archivos más grandes de un filesystem/disco
4. Mostrar memoria libre y swap en uso
5. Realizar copia de seguridad a memoria USB
6. Salir
-------------------------------------------
EOF
}

while true; do
  show_menu
  read -rp "Seleccione una opción [1-6]: " opt
  case "$opt" in
    1) show_users ;;
    2) show_filesystems ;;
    3) show_top_files ;;
    4) show_memory_swap ;;
    5) run_backup ;;
    6) echo "Saliendo..."; exit 0 ;;
    *) echo "Opción inválida. Intente nuevamente."; sleep 1 ;;
  esac
  echo
  read -rp "Presione Enter para volver al menú..."
done
