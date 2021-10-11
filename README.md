# BattlecatAdWatcher
![demo](demo.gif)

Autoclicker that watches BCE ads for you for catfood using adb and OpenCV.

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
To run this bot, you need to have a Debian system with the latest version of Bash installed. For your Android phone, I'm not sure what specific Android versions are supported, but I ran this on Android 11. In addition, you must have USB Debugging enabled on your android. 

After that, simply run `sudo apt-get install python3 adb` and `python3 -m pip install pillow opencv-python`. If you plan on building the project also run `sudo apt-get install cmake libopencv-dev g++`. 

## How it works
This bot is pretty simple and consists of two parts:
1. **adb**. Everything that directly interfaces with your phone and the app is done through this command. This includes touches, closing BCE, opening BCE, taking screenshots, detecting the current app, ect. A list of functions are in `adbAPI.bash` that contains shortcuts for these actions.
2. **OpenCV**. OpenCV is responsible for determining the location of the UI and the X's on the ads through screenshots. This is the crucial component that allows to work reliably with different ads, but is also the most resource-intensive. It is for this reason there are two versions of scripts that do this: `getcoords` executable compiled in C++ and `getcoords.py` in python. The C++ version is a lot faster and can be compiled from `cimgdec`. 

## How to use
Unless you are using a Oneplus Nord N10 5G cellphone, you'll have to follow these steps:
1. Take a screenshot of every piece of UI as shown in `imgdec` and replace each image with the same name. Screenshots MUST be done with `adb exec-out screencap -p > screen.png` or through the phone then cropped afterwards.
2. Manually watch a few ads and take screenshots of the closing symbols through the method mentioned before. Cropped images should go to `imgdec/ads`.
3. Run `bash main.bash` and reap the gains. If the bot is unable to close an ad after around 45s, a screenshot of it will go to `stuck/` (that will be created). Do step 2 again and move the image into `imgdec/ads` as before. This is how the bot "learns" how to close ads.




## How to Build
