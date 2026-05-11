#!/bin/sh
# Spustíme alarmcenter a budeme číst jeho výstup řádek po řádku
/mnt/app/alarmcenter 2>&1 | while read -r line; do
    case "$line" in
        *"MD state:1"*)
            echo "POHYB DETEKOVÁN!"
            # Zde může být váš příkaz, např.:
            # wget -qO- "http://vas-server.cz/log?status=pohyb"
            ;;
        *"MD state:0"*)
            echo "KLID..."
            ;;
    esac
done