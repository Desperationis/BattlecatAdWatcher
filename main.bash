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
	adb shell monkey -p $battlecats 1 > /dev/null 2>&1
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
	touch 2070 1000 # Press "skip"
	sleep 2s
	touch 1200 660 # Press "Start"
	sleep 2s
	touch 1200 660 # Press Chapter
	sleep 3s
}

navigateToChapter

while true
do
	touch 1820 1040 # Press Catfood
	sleep 10s
	touch 1300 350 # Press "Watch Media"
	sleep 50s
	touch 2340 70 # Press >>
	sleep 5s
	touch 2340 70 # Press X
	sleep 2s

	touch 1455 660 # Collect catfood
	sleep 1s

	if ! battleCatsRunning
	then
		navigateToChapter
	fi
done
