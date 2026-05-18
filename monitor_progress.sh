#!/bin/bash

cd "E:\dev\SwordOfConvallaria_LevelPreview"

total=493
remaining=$(git status --porcelain | grep -c '^?? web_levels/')
done=$((total - remaining))

# Only report when done is a multiple of 50 (or close)
if (( done % 50 == 0 )) || (( (done + 1) % 50 == 0 )) || (( (done + 2) % 50 == 0 )); then
    echo "=== PROGRESS UPDATE ==="
    echo "Folders done: $done / $total"
    echo "Folders remaining: $remaining"
    echo "Last commit: $(git log -1 --pretty=format:'%s (%h)')"
    echo "======================="
fi