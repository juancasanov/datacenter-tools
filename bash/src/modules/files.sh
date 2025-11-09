#!/usr/bin/env bash
# files.sh - mostrar 10 archivos más grandes en el filesystem especificado

show_top_files() {
  echo "== Buscar los 10 archivos más grandes en un directorio/mountpoint =="
  read -rp "Ruta del filesystem/disco (ej: /, /mnt/data, /media/usb): " target

  if [[ -z "$target" ]]; then
    echo "Ruta vacía. Cancelado."
    return 1
  fi

  if [[ ! -d "$target" ]]; then
    echo "La ruta especificada no es un directorio válido: $target"
    return 1
  fi

  echo "Escaneando (esto puede tardar)..."
  if find "$target" -maxdepth 0 >/dev/null 2>&1; then
    if find "$target" -type f -printf '%s\t%p\n' 2>/dev/null | sort -nr | head -n 10 | awk -F'\t' '{printf "%12s bytes  %s\n", $1, $2}'; then
      return 0
    fi
  fi

  if command -v stat >/dev/null 2>&1; then
    find "$target" -type f -print0 2>/dev/null | xargs -0 -n1 stat --format '%s %n' 2>/dev/null | sort -nr -k1,1 | head -n 10 | awk '{size=$1; $1=""; sub(/^ /,""); printf "%12s bytes  %s\n", size, $0}'
    return 0
  fi

  echo "ERROR: No se pudo obtener tamaños de archivo. 'find -printf' o 'stat' son necesarios."
  echo "Si estás en macOS, considera instalar GNU findutils/stat o ejecutar en Linux."
  return 1
}
