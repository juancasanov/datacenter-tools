#!/usr/bin/env bash
# disks.sh - listar filesystems/discos con tamaño y espacio libre (bytes)

show_filesystems() {
  echo "== Filesystems / Discos conectados (tamaño en bytes) =="

  if df -B1 . >/dev/null 2>&1; then
    df -B1 --output=source,size,avail,target 2>/dev/null | sed '1d' | awk '{printf "%-30s %15s bytes free on %s\n", $1, $3, $4}'
    return 0
  fi

  if df -k . >/dev/null 2>&1; then
    df -k | awk 'NR==1{next} {size=$2*1024; avail=$4*1024; printf "%-30s %15d bytes free on %s\n", $1, avail, $6}'
    return 0
  fi

  echo "ERROR: comando df no disponible."
}

