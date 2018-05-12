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
function DELAY {
sleep 1
}
function UNIXTIME {
date +%s
}

# Main Script Begins

while true; do

	COUNT=0
	echo "COUNT is currently: $COUNT" && echo
        echo "Incrementing COUNT by +1" && echo

	CLOCK=`date +%s` # Checks UNIX Time

	READING && echo "Sensor Detects: $stat" && echo # Checks Motion Sensor and saves either a 1 (movement) or 0 (no movement) to $stat

	while [ $stat == 1 ] 
	do
		echo " ### MOVEMENT ### " && echo
		#echo '___  ________  _   _ ________  ___ _____ _   _ _____'
		#echo '|  \/  |  _  || | | |  ___|  \/  ||  ___| \ | |_   _|'
		#echo '| .  . | | | || | | | |__ | .  . || |__ |  \| | | |'
		#echo '| |\/| | | | || | | |  __|| |\/| ||  __|| . ` | | |'
		#echo '| |  | \ \_/ /\ \_/ / |___| |  | || |___| |\  | | |'
		#echo '\_|  |_/\___/  \___/\____/\_|  |_/\____/\_| \_/ \_/' && echo

        	COUNT=$((COUNT+1))
	        echo "COUNT is now: $COUNT" && echo

		if [ "$COUNT" -lt "2" ]
		then
			echo "IF TRIGGERED - COUNT is LESS THAN 2.   -   Sleeping for 5..." && sleep 5
			cd /home/acawley/433MHz/433Utils/RPi_utils/ && sudo ./codesend 4706319
			#echo "UNIX Time - CLOCK = "
			#expr `UNIXTIME` - $CLOCK
		fi
		# && [ `expr `UNIXTIME` - $CLOCK` -le
		#cd /home/acawley/433MHz/433Utils/RPi_utils/ && sudo ./codesend 4706319
		READING && echo "Sensor Detects: $stat" && echo
		DELAY
	done


#		if [ $stat == 1 ]
#		then
#			echo "MOVEMENT!" && echo
#		fi
	echo "Nothing..." && echo
	DELAY
done
exit 0
# Everything below was experimenting with time and needs to be intergrated into the above

#UNIXTIME=`date +%s`

#function TIMETELL {
#date +%s
#}
#echo "The current number of seconds is $UNIXTIME" && echo

#echo "Sleeping 5 seconds..." && sleep 5 && echo

#echo "Taking away previous UNIX time away from current UNIX time..."

#	expr `TIMETELL` - $UNIXTIME


