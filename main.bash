#!/usr/bin/env bash

source adbAPI.bash

# Program start - assume device is unlocked and battlecats may or may not be
# open.

navigateToChapter() {
	restartBattleCats
	sleep 10s # TODO; replace this with Pillow python
	touch 2070 1000 # Press "skip"
	sleep 2s
	touch 1200 660 # Press "Start"
	sleep 2s
	touch 1200 660 # Press Chapter
	sleep 3s
}

counter=0
navigateToChapter

while true
do
	touch 1780 600
	touch 1820 1040 # Press Catfood
	sleep 4s
	touch 1300 350 # Press "Watch Media"
	sleep 45s
	touch 2340 70 # Press >>
	sleep 5s
	touch 2340 70 # Press X
	sleep 2s

	touch 1455 660 # Collect catfood
	sleep 1s

	(( counter++ ))

	if [[ $counter -ge 4 ]] || ! battleCatsRunning
	then
		navigateToChapter
		counter=0
	fi

	echo $counter
done
