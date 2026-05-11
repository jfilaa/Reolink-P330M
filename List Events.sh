#!/bin/sh

# Použijeme aktuální složku
DIR="."

echo "Čas zahájení | Detekce"
echo "--------------------------"

for file in $DIR/Rec*.mp4; do
    # Kontrola existence
    [ -f "$file" ] || continue

    # Náhrada za basename (oříznutí cesty přes parametr shellu)
    filename=${file##*/}

    # Extrakce času (HH:MM:SS)
    start_time=$(echo "$filename" | cut -d'_' -f3)
    h=$(echo "$start_time" | cut -c1-2)
    m=$(echo "$start_time" | cut -c3-4)
    s=$(echo "$start_time" | cut -c5-6)

    # Extrakce HEX části (např. CA)
    event_part=$(echo "$filename" | cut -d'_' -f5)
    hex=$(echo "$event_part" | cut -c5-6)
    
    # BusyBox neumí $((0xCA)), musíme použít printf k převodu na desítkové číslo
    dec=$(printf "%d" "0x$hex")

    detections=""

    # Bitové testy pomocí 'logic' (v BusyBoxu je jistější použít bitový AND přes awk nebo testovat hodnoty)
    # 64 = osoba, 16 = vozidlo, 8 = zvíře
    
    # Pomocná funkce pro simulaci bitového AND pomocí celočíselného dělení
    is_person=$(( (dec / 64) % 2 ))
    is_vehicle=$(( (dec / 16) % 2 ))
    is_animal=$(( (dec / 8) % 2 ))

    if [ "$is_person" -eq 1 ]; then
        detections="osoba"
    fi

    if [ "$is_vehicle" -eq 1 ]; then
        [ -n "$detections" ] && detections="$detections + "
        detections="${detections}vozidlo"
    fi

    if [ "$is_animal" -eq 1 ]; then
        [ -n "$detections" ] && detections="$detections + "
        detections="${detections}zvíře"
    fi

    if [ -z "$detections" ]; then
        detections="pohyb"
    fi

    echo "$h:$m:$s | $detections"
done