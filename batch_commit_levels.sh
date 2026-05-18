#!/bin/bash

set -e

cd "E:\dev\SwordOfConvallaria_LevelPreview"

echo "Starting batch commit & push for web_levels folders..."
echo "Remote: origin (git@github.com:spotco/SwordOfConvallaria_LevelPreview.git)"
echo ""

count=0
rate_limit_count=0

for dir in web_levels/*/; do
    folder_name=$(basename "$dir")
    
    echo "[$((count+1))] Processing: $folder_name"
    
    # Add the folder
    git add "$dir"
    
    # Commit (only if there are changes)
    if git diff --cached --quiet; then
        echo "  -> No changes to commit for $folder_name, skipping."
        continue
    fi
    
    git commit -m "$folder_name"
    
    # Push
    echo "  -> Pushing..."
    push_output=$(git push origin HEAD 2>&1) || true
    echo "$push_output"
    
    # Check for rate limit / abuse detection
    if echo "$push_output" | grep -qiE "(rate limit|secondary rate limit|abuse detection|push declined|too many requests|slow down)"; then
        rate_limit_count=$((rate_limit_count + 1))
        echo ""
        echo "!!! RATE LIMIT DETECTED for $folder_name !!!"
        echo "Waiting 30 seconds before continuing..."
        echo ""
        sleep 30
    fi
    
    count=$((count + 1))
    
    # Small delay between pushes to be nicer to GitHub
    sleep 2
done

echo ""
echo "Done! Processed $count folders."
echo "Rate limits encountered: $rate_limit_count"