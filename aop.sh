#!/bin/sh

addition() {
	sum=0		
	for i in $@; do
		sum=$(( sum + i ))
	done
	echo "${sum}"
}

while :
do
	read -p "Enter operation (1) Addition, (2) Subtraction, (3) Division, (4) Multiplication, (5) Exit program" OPERATION
	case $OPERATION in
		1) echo 
			read -p "Enter numbers separated by spaces: " input_string
			set -- $input_string
			result=$(addition "$@")
			echo $result
			;;
		2) echo Subtraction 	;;
		3) echo Division 	;;
		4) echo Multiplication	;;
		5) exit			;;
		*) echo "${OPERATION} is an invalid input."	;;
	esac 
done
