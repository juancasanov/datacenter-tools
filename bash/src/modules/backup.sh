#!/usr/bin/env bash
# backup.sh - realizar copia de seguridad de un directorio a memoria USB y generar catálogo

run_backup() {
  echo "== Backup a memoria USB =="
  read -rp "Directorio origen (ruta absoluta): " src
  if [[ -z "$src" || ! -d "$src" ]]; then
    echo "Directorio origen inválido."
    return 1
  fi

  read -rp "Punto de montaje de la USB destino (ej: /media/$USER/USB o /mnt/usb): " dst
  if [[ -z "$dst" || ! -d "$dst" ]]; then
    echo "Directorio destino inválido o no montado: $dst"
    return 1
  fi

  dst_avail=$(df -B1 --output=avail "$dst" 2>/dev/null | tail -n1 | tr -d ' ')
  if [[ -n "$dst_avail" ]]; then
    echo "Espacio libre en destino: $dst_avail bytes"
  fi

  if ! command -v rsync >/dev/null 2>&1; then
    echo "Se recomienda instalar rsync para realizar la copia. Intentando cp recursivo como fallback."
    echo "Usando cp -a (no preserva algunas opciones avanzadas)."
    echo "Iniciando copia..."
    cp -a "$src"/. "$dst"/ || { echo "Error copiando con cp"; return 1; }
  else
    echo "Iniciando rsync..."
    rsync -a --info=STATS2 "$src"/ "$dst"/ || { echo "rsync falló"; return 1; }
  fi

  catalog="$dst/backup_catalog_$(date +%Y%m%d_%H%M%S).csv"
  echo "path,size_bytes,modified_iso" >"$catalog"

  if command -v stat >/dev/null 2>&1; then
    find "$dst" -type f -print0 2>/dev/null | while IFS= read -r -d $'\0' file; do
      size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)
      mtime=$(stat -c%y "$file" 2>/dev/null || stat -f%Sm -t "%Y-%m-%d %H:%M:%S" "$file" 2>/dev/null)
      escaped_path=$(printf '%s' "$file" | sed 's/"/""/g')
      printf "\"%s\",%s,\"%s\"\n" "$escaped_path" "$size" "$mtime" >>"$catalog"
    done
  else
    echo "WARNING: 'stat' no disponible; generando catálogo básico usando 'ls -lR' (menos preciso)."
    find "$dst" -type f -print0 | xargs -0 -I{} sh -c 'printf "\"%s\",%s,\"%s\"\n" "{}" "$(wc -c <"{}")" "$(date -r "{}" +"%Y-%m-%d %H:%M:%S")"' >>"$catalog"
  fi

  echo "Copia completada. Catálogo guardado en: $catalog"
  return 0
}
