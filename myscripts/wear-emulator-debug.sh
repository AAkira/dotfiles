adb -s -d 192.168.56.101:5555 forward  tcp:5605 tcp:5605
adb -s -d emulator-5554 forward  tcp:5605 tcp:5605
