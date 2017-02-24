#!/bin/sh

DATE=`date '+%y%m%d%H%M%S'`
FILE_NAME=screenshot-${DATE}.png
YOUR_PATH=~/Desktop

. ../conf.txt
TOKEN=$VALENCIA_SLACK_TOKEN

adb shell screencap -p /sdcard/${FILE_NAME}
adb pull /sdcard/${FILE_NAME} ${YOUR_PATH}
adb shell rm /sdcard/${FILE_NAME}

echo "Rotate? [y]"
read isRotate
case $isRotate in
	"y" | "Y") sips -r 270 ${YOUR_PATH}/${FILE_NAME} # only use in OSX
						;;
 	*) ;;
esac

echo "Upload to slack? [y]"
read isUpload
case $isUpload in
	"y" | "Y") ;;
 	*) exit 0;;
esac

echo "Input a channel name : "
read channelName

curl -XPOST -F "token=$TOKEN" -F "channels=#$channelName" -F "file=@$YOUR_PATH/$FILE_NAME" -F "filename=$FILE_NAME" "https://slack.com/api/files.upload"
