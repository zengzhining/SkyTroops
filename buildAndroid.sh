#/sbin/sh
#git pull origin master 
cocos compile -p android --ap android-19 --ndk-toolchain     arm-linux-androideabi-4.8
cd ./simulator/android
adb uninstall com.sadi.spaceShooter
adb install piexPlane-debug.apk


