#!/usr/bin/env bash

IMAGE_DIR="/home/marco/Bilder/wallpaper"	# directory with wallpapers
TIMEOUT=900									# timeout
SHUFFLE=1									# shuffling (0-2)
LOGFILE="${HOME}/.wallpaperchanger.log"		# logfile

##
## external config
##

if [ -f "${HOME}/.config/wallpaperchanger.conf" ]; then
	source "${HOME}/.config/wallpaperchanger.conf"
fi

##
## signal handlers
##

trap signalUSR SIGUSR1
trap signalHUP SIGHUP
trap "exit 0" SIGTERM SIGKILL SIGSTOP SIGINT

##
## functions
##

# write log
function log {
	local LOG_PREFIX=${2}
	if [ x"${1}" != x ]; then
		if [ x"${LOG_PREFIX}" = x ]; then 
			LOG_PREFIX="INFO"
		fi
		echo -e "$(date +%Y-%m-%d' '%H:%M:%S) - ${LOG_PREFIX}: ${1}" >> ${LOGFILE}
	fi
}

# update image cache
function updateCache {
	log "Update Cache. Random level is ${SHUFFLE}"
	if [ ${SHUFFLE} -eq 0 ]; then
		IMAGES=( $( find ${IMAGE_DIR} -type f \( -name "*.jpg" -or -name "*.png" \) ) )
	else
		IMAGES=( $( find ${IMAGE_DIR} -type f \( -name "*.jpg" -or -name "*.png" \) | shuf ) )
	fi
	CURRENT_INDEX=0
}

# set next picture as background
function nextImage {
	if [ ${SHUFFLE} -gt 1 ]; then
		RANDOM_INDEX=$(( $RANDOM % ${#IMAGES[@]} ))
		pcmanfm -w "${IMAGES[$RANDOM_INDEX]}"
		resetTimer
	else
		if [ ${CURRENT_INDEX} -lt ${#IMAGES[@]} ]; then
			pcmanfm -w "${IMAGES[$CURRENT_INDEX]}"
			resetTimer
			(( CURRENT_INDEX++ ))
		else
			updateCache
			nextImage
		fi
	fi
}

# resets the timer
function resetTimer {
	[[ "${SLEEP_PID}" == +([0-9]) ]] && kill -0 ${SLEEP_PID} >/dev/null 2>&1 && kill ${SLEEP_PID} >/dev/null 2>&1
	sleep ${TIMEOUT} &
	SLEEP_PID=$!
}

# set next image on SIGUSR1
function signalUSR {
	log "SIGUSR1 detected." INFO
	SIGNAL_CAUGHT=true
	nextImage
}

# update image cache on SIGHUP
function signalHUP {
	log "SIGHUP detected." INFO
	SIGNAL_CAUGHT=true
	updateCache
}

##
## main program
##

log "Starting wallpaperchanger on $(date +%Y-%m-%d" "%H:%M:%S)" "INFO"
updateCache

while true; do
	if [ "${SIGNAL_CAUGHT}" = true ]; then
		SIGNAL_CAUGHT=false
	else
		nextImage
	fi
	wait ${SLEEP_PID}
done
