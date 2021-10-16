#!/usr/bin/env bash

source adbAPI.bash

# Program start - assume device is unlocked and battlecats may or may not be
# open.

navigateToChapter() {
	restartBattleCats
	scounter=0
	while true
	do
		screenshot
		if clickImageCache skip.png
		then
			break
		fi

		if [[ scounter -ge 15 ]]
		then
			restartBattleCats
			scounter=0
		fi

		((scounter++))
	done
	clickFoundImage play.png
	clickFoundImage chapter.png
}

counter=0
navigateToChapter

while true
do

	# Very important. This section clicks any daily banners / awards until
	# catfood has been pressed. The 2s wait is to wait for banners
	sleep 2
	ccounter=0
	while true
	do
		screenshot
		clickImageCache bigOk.png
		clickImageCache smallOk.png
		clickImageCache ok.png

		clickImageCache eventX.png 
		echo "Searching xx"

		if [[ $ccounter -gt 1 ]]
		then
			if clickImageCache catfood.png .95
			then
				break
			fi
		fi

		# Restart if for whatever reason we get stuck
		if [[ $ccounter -gt 5 ]] 
		then
			restartBattleCats
			quit=true
			break
		fi

		((ccounter++))
	done
	echo "Exit"

	ccounter=0
	quit=false
	while true
	do
		screenshot
		if clickImageCache watch.png 
		then
			break
		fi

		# Restart if for whatever reason we get stuck
		if [[ $ccounter -gt 5 ]] 
		then
			restartBattleCats
			quit=true
			break
		fi
	done

	if [[ $quit == true ]]
	then
		continue
	fi

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
				if clickImageCache "${file#imgdec/}" .97
				then
					touch "$file"
				fi
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

	if [[ $counter -ge 5 ]]
	then
		navigateToChapter
		counter=0
	fi
done
