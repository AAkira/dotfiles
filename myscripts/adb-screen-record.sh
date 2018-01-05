#!/bin/sh

DATE=`date '+%y%m%d%H%M%S'`
FILE_NAME=record-${DATE}
YOUR_PATH=~/Desktop

SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR # move script directory
source ../conf.txt
TOKEN=$VALENCIA_SLACK_TOKEN

adb shell screenrecord /sdcard/${FILE_NAME}.mp4 &
pid=`ps x | grep -v grep | grep "adb shell screenrecord" | awk '{ print $1 }'`

if [ -z "$pid" ]; then
  printf "Not running a screenrecord."
	exit 1
fi

printf "Recording, finish? [y]"
while read isFinished; do
  case "$isFinished" in
    "y" | "Y") break ;;
    *) printf "Incorrect value." ;;
  esac
done

kill -9 $pid # Finish the process of adb screenrecord

while :
do
  alive=`adb shell ps | grep screenrecord | grep -v grep | awk '{ print $9 }'`
  if [ -z "$alive" ]; then
      break
  fi
done

printf "Finish the recording process : $pid\nSending to $YOUR_PATH...\n"

adb pull /sdcard/${FILE_NAME}.mp4 $YOUR_PATH
adb shell rm /sdcard/${FILE_NAME}.mp4

echo "Converts to GIF? [y]"
read convertGif
case $convertGif in
	"y" | "Y") ffmpeg -i ${YOUR_PATH}/${FILE_NAME}.mp4 -an -r 12 -pix_fmt rgb24 -vf scale=iw*2/3:ih*2/3 -f gif ${YOUR_PATH}/${FILE_NAME}.gif # creating gif 
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

curl -XPOST -F "token=$TOKEN" -F "channels=#$channelName" -F "file=@${YOUR_PATH}/${FILE_NAME}.gif" -F "filename=${FILE_NAME}.gif" "https://slack.com/api/files.upload"
