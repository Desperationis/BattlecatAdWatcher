#!/usr/bin/env bash

source adbAPI.bash

# Program start - assume device is unlocked and battlecats may or may not be
# open.

navigateToChapter() {
	restartBattleCats
	clickFoundImage skip.png	
	clickFoundImage play.png
	clickFoundImage chapter.png
}

counter=0
navigateToChapter

while true
do
	touch 1780 600 # In case we run out of ads, press "Close"
	clickFoundImage catfood.png
	clickFoundImage watch.png

	timer=0
	while true
	do
		echo $timer
		screenshot

		if clickImageCache ok.png || clickImageCache systemok.png
		then
			break
		fi

		if [[ $timer -gt 4 ]]
		then
			if python3 isBlack.py
			then
				counter=0
				navigateToChapter
				break
			fi
		fi

		if [[ $timer -gt 15 ]]
		then

			for file in imgdec/ads/*
			do
				clickImageCache "${file#imgdec/}" .97
			done
		fi

		if [[ $timer -gt 45 ]]
		then
			mkdir stuck
			mv screen.png stuck/$(date +%s).png
			counter=0
			navigateToChapter
			break
		fi

		if ! battleCatsRunning
		then
			counter=0
			navigateToChapter
			break
		fi

		# Timer is solely based on the fact that "screenshot" func takes about 1 sec
		((timer++))
	done

	(( counter++ ))

	if [[ $counter -ge 10 ]]
	then
		navigateToChapter
		counter=0
	fi
done
