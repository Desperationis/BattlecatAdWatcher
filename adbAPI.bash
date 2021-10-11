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

tap() {
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

screenshot() {
	adb exec-out screencap -p > screen.png
}

clickFoundImage() {
	screenshot

	templateName=$1	
	accuracy=.80

	if [[ $# -ge 2 ]]
	then
		accuracy=$2
	fi

	#coords=$(python3 getcoords.py ./imgdec/$templateName screen.png $accuracy)
	coords=$(./getcoords ./imgdec/$templateName screen.png $accuracy)
	coordsFound=$?
	until [[ $coordsFound -eq 0 ]]
	do
		screenshot
		#coords=$(python3 getcoords.py ./imgdec/$templateName screen.png $accuracy)
		coords=$(./getcoords ./imgdec/$templateName screen.png $accuracy)
		coordsFound=$?
	done

	tap $coords
}




clickImageCache() {
	templateName=$1	
	accuracy=.80

	if [[ $# -ge 2 ]]
	then
		accuracy=$2
	fi

	#coords=$(python3 getcoords.py ./imgdec/$templateName screen.png $accuracy)
	coords=$(./getcoords ./imgdec/$templateName screen.png $accuracy)
	coordsFound=$?

	if [[ $coordsFound -ne 0 ]]
	then
		return 1
	fi

	tap $coords
}
