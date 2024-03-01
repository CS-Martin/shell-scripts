#!/bin/sh

addition() 
{
	echo "Add two numbers:"
	echo "Enter"
	read a
	read b

	res=$(( a + b ))
	echo "${res}"
}

echo -e "Enter operation\n"
echo "(1) Addition"
echo "(2) Subtraction"
echo "(3) Division"
echo "(4) Multiplication"
echo "(5) Exit program"

while :
do
	read OPERATION
	case $OPERATION in
		1) echo 
			read string
			addition string
			;;
		2) echo Subtraction 	;;
		3) echo Division 	;;
		4) echo Multiplication	;;
		5) exit			;;
		*) echo "${OPERATION} is an invalid input."	;;
	esac 
done

