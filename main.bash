#!/usr/bin/env bash

adbVersion=$(adb version | grep -Eo "1\.0\..+")

if ! [[ $adbVersion =~ 1\.0\.[3-9].+ ]]
then
	echo "ERROR: Adb version 1.0.39+ not installed."
	exit 1
fi

if ! adb devices | grep -Es "\sdevice$" > /dev/null
then
	echo "Device not connected"
	exit 1
fi



battlecats=jp.co.ponos.battlecatsen 

# Wrapper functions
launchBattleCats () {
	adb shell monkey -p $battlecats 1 > /dev/null 2&>1
}

touch() {
	if [[ $# -eq 2 ]] 
	then
		adb shell input tap $1 $2
	else
		return 1
	fi
}

swipe () {
	# X1 Y1 X2 Y2 DURATION
	if [[ $# -eq 5 ]]
	then
		adb shell input swipe $1 $2 $3 $4 $5
	else
		return 1
	fi
}

longpress () {
	# X1 Y1 DURATION
	if [[ $# -eq 5 ]]
	then
		adb shell input swipe $1 $2 $1 $2 $3
	else
		return 1
	fi
}

home() {
	adb shell input keyevent 3
}

battleCatsRunning() {
	(adb shell "dumpsys activity activities | grep ResumedActivity | grep -Eo $battlecats" > /dev/null 2>&1)
	return $?
}

killBattleCats() {
	adb shell am force-stop $battlecats
}

restartBattleCats () {
	killBattleCats
	sleep 2s
	launchBattleCats
}

listAllApps () {
	adb shell cmd package list packages
}



# Program start - assume device is unlocked and battlecats may or may not be
# open.

navigateToChapter() {
	restartBattleCats
	sleep 10s # TODO; replace this with Pillow python
	touch 2100 1000 # Press "skip"
	sleep 2s
	touch 1200 600 # Press "Start"
	sleep 2s
	touch 1200 600 # Press Chapter
	sleep 3s
}

navigateToChapter

count=0
while true
do
	if [[ count -eq 0 ]]
	then
		navigateToChapter
		count=0
	fi
	touch 1820 1040 # Press Catfood
	sleep 10s
	touch 1300 350 # Press "Watch Media"
	sleep 30s
	touch 2310 82 # Press X
	sleep 5s

	if ! battleCatsRunning
	then
		navigateToChapter
	else
		touch 1475 660
		sleep 1s
	fi

	let "count++"
	echo $count
done
