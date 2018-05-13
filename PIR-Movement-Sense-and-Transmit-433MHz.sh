#!/bin/bash

# Sudo Code
# If movement is detected then send 433MHz ON signal to monitors
# If NO movement is deteced at any point during an extended period (15mins) send 433MHz OFF signal to monitors

# Only need to run once:
echo "4" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio4/direction

# Functions
function READING {
trap 'echo "4" > /sys/class/gpio/unexport' 0
stat=`cat /sys/class/gpio/gpio4/value`
}
function CHECKDELAY {
sleep 3
}

# Main Script Begins

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


		cd /home/acawley/433MHz/433Utils/RPi_utils/ && sudo ./codesend 4706319
		READING
		echo "Sleeping for 10 minutes..." && echo && sleep 600
	done


	echo "Nothing..." && echo
	CHECKDELAY
done
exit 0
