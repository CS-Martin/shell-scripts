#!/bin/bash

create() {

}

# Define CSV file
csv_file="data.csv"

if [ ! -e "$csv_file" ]; then
	echo "Name,Age" >$csv_file
fi

while read -p "Enter operation: " operation; do

done
