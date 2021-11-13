#!/usr/bin/env bash

if ! [[ -e log.txt ]]
then
	touch log.txt
fi

source adbAPI.bash

export -f tap
export -f swipe
export -f longpress
export -f screenshot
export -f clickImageCache
export -f clickFoundImage


# Program start - assume device is unlocked and battlecats may or may not be
# open.

changeBrightness 0

navigateToChapter() {
	# Restart battle cats and navigate to main chapter menu.

	restartBattleCats

	log "Navigating to the main chapter menu."
	until clickFoundImage skip.png 15 && { clickFoundImage play.png 15 && clickFoundImage chapter.png 15; }
	do
		log "There was an error navigating main menu. Restarting..."
		restartBattleCats
	done
	log "Arrived at main chapter menu."
}

log () {
	message=$1
	timestamp=$(date)

	echo "$timestamp: $message" | tee -a log.txt
}

counter=0
navigateToChapter

while true
do
	log " "

	# Check if we are in main menu or daily special event menu
	log "Checking screenshot to confirm we are at the menu."
	sleep 2
	screenshot
	if imageFound start.png
	then
		log "We are in the chapter menu. Trying to click catfood."
		if ! clickFoundImage catfood.png 10 .95
		then
			log "Not able to find catfood on chapter menu. Restarting loop."
			navigateToChapter
			continue
		else
			log "Catfood was clicked."
		fi
	else
		log "We are not in the chapter menu. Trying to close daily events."

		SECONDS=0
		until (( SECONDS >= 60 )) || imageFound start.png
		do
			screenshot
			clickImageCache bigOk.png
			clickImageCache smallOk.png
			clickImageCache ok.png
			clickImageCache eventX.png 
			clickImageCache back.png 
		done

		if (( SECONDS >= 60 ))
		then
			log "Not able to close events. Restarting Battle Cats and loop."
			navigateToChapter
			continue
		else
			log "Able to close all events. Restarting loop."
			navigateToChapter
			continue
		fi
	fi



	# Click ad offer and repeat loop if unable to
	log "Trying to click ad offer."
	SECONDS=0
	if clickFoundImage watch.png 15
	then
		log "Offer was able to be clicked."
	else
		log "Offer was unable to be clicked. Restarting Battle Cats and loop."
		navigateToChapter
		continue
	fi



	# Auto close the ad
	log "Watching ad and trying to close it. This might take awhile."
	SECONDS=0
	while true
	do
		screenshot

		if clickImageCache ok.png
		then
			log "Ad has ended."
			break
		fi

		if clickImageCache systemok.png
		then
			log "Ran out of ads. Reloading battle cats..."
			#navigateToChapter
			break
		fi

		if (( SECONDS >= 5 ))
		then
			if python3 isBlack.py
			then
				log "Ad crashed. Restarting battlecats and loop."
				navigateToChapter
				break
			fi
		fi

		if (( SECONDS >= 15 ))
		then
			# Scan ads
			for file in imgdec/ads/*
			do
				if clickImageCache "${file#imgdec/}" .97
				then
					touch "$file" # Used to keep track of rarely used ad images
				fi
			done
		fi

		if (( SECONDS >= 60 ))
		then
			log "Can't close this ad, moving screenshot to stuck/ and restarting."

			if ! [[ -d stuck ]]
			then
				mkdir stuck
			fi	

			mv screen.png stuck/$(date +%s).png
			navigateToChapter
			break
		fi

		if ! battleCatsRunning
		then
			log "Foreign app was opened. Restarting battlecats and loop."
			navigateToChapter
			break
		fi
	done
done
