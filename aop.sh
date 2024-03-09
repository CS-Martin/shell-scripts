#!/bin/sh

addition() {
	sum=0
	for i in $@; do
		sum=$((sum + i))
	done
	echo "${sum}"
}

subtraction() {
	diff=$(($1 - $2))
	echo $diff
}

division() {
	quo=$(($1 / $2))
	echo $quo
}

multiplication() {
	prod=1
	for i in $@; do
		prod=$((prod * i))
	done
	echo $prod
}

while :; do
	read -p "Enter operation (1) Addition, (2) Subtraction, (3) Division, (4) Multiplication, (5) Exit program" OPERATION
	case $OPERATION in
	1)
		echo
		read -p "Enter numbers separated by spaces: " input_string
		set -- $input_string
		result=$(addition "$@")
		echo $result
		;;
	2)
		echo
		read -p "Enter two numbers: " input_string
		set -- $input_string
		result=$(subtraction "$@")
		echo $result
		;;
	3)
		echo
		read -p "Enter two numbers: " input_string
		set -- $input_string
		result=$(division "$@")
		echo $result
		;;
	4)
		echo
		read -p "Enter numbers separated by spaces: " input_string
		set -- $input_string
		result=$(multiplication "$@")
		echo $result
		;;
	5) exit ;;
	*) echo "${OPERATION} is an invalid input." ;;
	esac
done
