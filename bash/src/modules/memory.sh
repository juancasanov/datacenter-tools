#!/usr/bin/env bash
# memory.sh - mostrar memoria libre y swap en bytes y porcentaje

show_memory_swap() {
  echo "== Memoria y swap =="

  if command -v free >/dev/null 2>&1; then
    if free -b >/dev/null 2>&1; then
      free -b | awk 'NR==2{total=$2; free=$7; used=total-free; printf "Memoria total: %d bytes\nMemoria libre: %d bytes\nMemoria usada: %d bytes (%.2f%%)\n\n", total, free, used, (used/total)*100}
                      NR==3{stotal=$2; sfree=$4; sused=stotal-sfree; printf "Swap total: %d bytes\nSwap libre: %d bytes\nSwap usado: %d bytes (%.2f%%)\n", stotal, sfree, sused, (stotal>0)?(sused/stotal*100):0 }'
      return 0
    fi
  fi

  if [[ -r /proc/meminfo ]]; then
    awk '/MemTotal:/{mt=$2*1024}/MemFree:/{mf=$2*1024}/MemAvailable:/{ma=$2*1024}/SwapTotal:/{st=$2*1024}/SwapFree:/{sf=$2*1024}
         END{
           used=mt-ma;
           printf "Memoria total: %d bytes\nMemoria disponible: %d bytes\nMemoria usada (aprox): %d bytes (%.2f%%)\n\n", mt, ma, used, (used/mt)*100;
           sused=st-sf;
           printf "Swap total: %d bytes\nSwap libre: %d bytes\nSwap usado: %d bytes (%.2f%%)\n", st, sf, sused, (st>0)?(sused/st*100):0
         }' /proc/meminfo
    return 0
  fi

  echo "ERROR: No se puede obtener información de memoria. 'free' o /proc/meminfo necesarios."
}
