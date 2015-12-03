#!/usr/bin/env bash

IMAGE_DIR="/home/marco/Bilder/wallpaper"    # directory with wallpapers
TIMEOUT=900                                 # timeout
RANDOM_ORDER=false                          # random order

function updateCache {
    IMAGES=( $( find ${IMAGE_DIR} -type f \( -name "*.jpg" -or -name "*.png" \) ) )
    CURRENT_INDEX=0
}

function nextImage {
    if [ "${RANDOM_ORDER}" = true ]; then
        RANDOM_INDEX=$(( $RANDOM % ${#IMAGES[@]} ))
        pcmanfm -w "${IMAGES[$RANDOM_INDEX]}"
    else
        if [ ${CURRENT_INDEX} -lt ${#IMAGES[@]} ]; then
            pcmanfm -w "${IMAGES[$CURRENT_INDEX]}"
            (( CURRENT_INDEX++ ))
        else
            updateCache
        fi
    fi
}

updateCache

while true; do
    nextImage
    sleep ${TIMEOUT}
done
