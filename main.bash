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
		screenshot
		if clickImageCache ok.png || clickImageCache systemok.png
		then
			break
		fi

		if [[ $timer > 20 ]]
		then
			clickImageCache x.png .93
			clickImageCache dash.png .93
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
