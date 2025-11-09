#!/usr/bin/env bash
# users.sh - listar usuarios y último ingreso

show_users() {
  echo "== Usuarios del sistema y último login =="

  if command -v lastlog >/dev/null 2>&1; then
    lastlog | column -t
    return 0
  fi

  if command -v last >/dev/null 2>&1; then
    echo "lastlog no disponible: usando 'last' como fallback (puede contener múltiples entradas por usuario)"
    last -n 50 | head -n 50
    return 0
  fi  

  echo "ERROR: ni 'lastlog' ni 'last' están disponibles en el sistema."
  echo "Instala util-linux o revisa tu entorno."
}
