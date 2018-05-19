#!/bin/bash

# This script is designed to run continuously, it uses a PIR motion sensor to detect
# movement and when it does it sends a wireless signal via a 433MHz Transmitter to
# switch on a remote controlled plug. This proof of concept is currently being used
# to automatically switch on my multi-monitor setup when I enter my office but could
# be utilised to perform other tasks instead.

# Functions
function READING {
trap 'echo "4" > /sys/class/gpio/unexport' 0
stat=`cat /sys/class/gpio/gpio4/value`
}
function CHECKDELAY {
sleep 3
}

# Main Script Begins

echo -e "\f" # Clears the screen

if [ `whoami` == 'root' ]
then
	# Sets up GPIO Pins and gets ready to take PIR sensor readings
	echo "4" > /sys/class/gpio/export
	echo "in" > /sys/class/gpio/gpio4/direction

	while true; do

	READING && echo "Sensor Detects: $stat" && echo # Checks Motion Sensor and saves either a 1 (movement) or 0 (no movement) to $stat

	while [ $stat == 1 ] 
	do
		#echo " ### MOVEMENT ### " && echo
		echo '___  ________  _   _ ________  ___ _____ _   _ _____'
		echo '|  \/  |  _  || | | |  ___|  \/  ||  ___| \ | |_   _|'
		echo '| .  . | | | || | | | |__ | .  . || |__ |  \| | | |'
		echo '| |\/| | | | || | | |  __|| |\/| ||  __|| . ` | | |'
		echo '| |  | \ \_/ /\ \_/ / |___| |  | || |___| |\  | | |'
		echo "\_|  |_/\___/  \___/\____/\_|  |_/\____/\_| \_/ \_/ detected at `date +%F_%T`" && echo
		
		# Add an entry to the movement.log to log that there has been movement detected
		echo "Movement detected at `date +%F_%T`" >> ./movement.log && echo >> ./movement.log

		cd /home/acawley/433MHz/433Utils/RPi_utils/ && sudo ./codesend 4706319
		READING
		echo "Sleeping for 10 minutes..." && echo && sleep 600
	done


		echo "Nothing..." && echo
		CHECKDELAY
	done
	exit 0
fi
echo "You are not root - please run this script using sudo or as root."
exit 1
