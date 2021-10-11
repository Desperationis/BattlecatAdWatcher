# BattlecatAdWatcher
![demo](demo.gif)

Autoclicker that watches battlecat ads for you for catfood using adb and OpenCV.

## Features
This bot can:
1. Farm catfood overnight reliably (60 CF / h)
2. "Learn" how to close ads over time through OpenCV template matching
3. Easily be modified if UI updates come. 
4. Control BC directly from the command line; No mirroring needed.
5. Recover from ad crashes
6. Be run on a Raspberry Pi. 
7. Work on non-rooted phones. 

## Drawbacks
This bot, as of right now, can't:
* Navigate through the UI of surprise daily events, i.e. gacha banners
* Work right out of the box
* Navigate through chapters; Chapters must be visible the moment you press "Start" on the menu (look at gif).

## Requirements
To run this bot, you need to have a Debian system with the latest version of Bash installed. For your Android phone, I'm not sure what specific Android versions are supported, but I ran this on Android 11. 

After that, simply run `sudo apt-get install python3 adb` and `python3 -m pip install pillow opencv-python`. If you plan on building the project also run `sudo apt-get install cmake libopencv-dev`. 


## How to use


## How to Build
