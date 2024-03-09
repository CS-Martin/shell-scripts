#!/bin/bash

# Define colors
export COLOR_RESET=$(tput sgr0)
export PURPLE=$(tput setaf 5)
export BLUE=$(tput setaf 4)
export GREEN=$(tput setaf 2)
export RED=$(tput setaf 1)

# Terminal header and horizontal rule
export terminal_header="

${PURPLE}
█████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ 

██╗   ██╗██╗    ██╗██╗███████╗    ███████╗███╗   ██╗██████╗  ██████╗ ██╗     ██╗     ███╗   ███╗███████╗███╗   ██╗████████╗
██║   ██║██║    ██║██║██╔════╝    ██╔════╝████╗  ██║██╔══██╗██╔═══██╗██║     ██║     ████╗ ████║██╔════╝████╗  ██║╚══██╔══╝
██║   ██║██║ █╗ ██║██║███████╗    █████╗  ██╔██╗ ██║██████╔╝██║   ██║██║     ██║     ██╔████╔██║█████╗  ██╔██╗ ██║   ██║   
██║   ██║██║███╗██║██║╚════██║    ██╔══╝  ██║╚██╗██║██╔══██╗██║   ██║██║     ██║     ██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   
╚██████╔╝╚███╔███╔╝██║███████║    ███████╗██║ ╚████║██║  ██║╚██████╔╝███████╗███████╗██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   
 ╚═════╝  ╚══╝╚══╝ ╚═╝╚══════╝    ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   

█████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ 
                                                                              
${COLOR_RESET}
"
export hr="====================================================================================="

# Loading animation
loading_animation() {
	echo -e "${GREEN}\n"

	echo -ne "\rLoading."
	echo -ne '|====>                   |  (12%)\r'
	sleep 1

	echo -ne "\rLoading.."
	echo -ne '|============>           |  (47%)\r'
	sleep 1

	echo -ne "\rLoading..."
	echo -ne '|===============>        |  (66%)\r'
	sleep 0.3

	echo -ne "Loading."
	echo -ne '|====================>   |  (92%)\r'
	sleep 1

	echo -ne "Loading.."
	echo -ne '|=======================>|  (100%)\r'
	sleep 0.4
	echo -ne '\n'
	${COLOR_RESET}
}

# Print subject list
print_subjects() {
	printf "| %-10s | %-12s | %-30s | %-20s |\n" "SUBJECT_ID" "SUBJECT_CODE" "SUBJECT_NAME" "SCHEDULE"
	echo $hr
	tail -n +2 "$db" | while IFS=, read -r SUBJECT_ID SUBJECT_CODE SUBJECT_NAME SCHEDULE; do
		printf "| %-10s | %-12s | %-30s | %-20s |\n" "$SUBJECT_ID" "$SUBJECT_CODE" "$SUBJECT_NAME" "$SCHEDULE"
	done
	echo $hr
}

# Add subject
add_subject() {
	clear
	echo "$terminal_header"
	echo $hr
	echo -e "\t\t\t\t   ADD SUBJECT"
	echo $hr

	if [ -e "$db" ]; then
		LAST_SUBJECT_ID=$(tail -n 1 "$db" | cut -d',' -f1)
		SUBJECT_ID=$((LAST_SUBJECT_ID + 1))
	else
		SUBJECT_ID=1
	fi

	read -p "Enter Subject Code: " SUBJECT_CODE
	read -p "Enter Subject Name: " SUBJECT_NAME
	read -p "Enter Subject Schedule: " SUBJECT_SCHEDULE

	echo "$SUBJECT_ID,$SUBJECT_CODE,$SUBJECT_NAME,$SUBJECT_SCHEDULE" >>"$db"

	loading_animation

	clear
	echo "$terminal_header"
	echo "${GREEN}"
	echo $hr
	echo -e "\t\t\t    SUBJECT ADDED SUCCESSFULLY."
	echo $hr
	echo "${COLOR_RESET}"

	echo -e "\nSubject Details: "
	echo $hr
	printf "| %-10s | %-12s | %-30s | %-20s |\n" "SUBJECT_ID" "SUBJECT_CODE" "SUBJECT_NAME" "SCHEDULE"
	echo $hr
	printf "| %-10s | %-12s | %-30s | %-20s |\n" "$SUBJECT_ID" "$SUBJECT_CODE" "$SUBJECT_NAME" "$SUBJECT_SCHEDULE"
	echo $hr

	echo ""
	read -p "Press any key to continue..."
}

# Drop subject
drop_subject() {
	clear
	echo "$terminal_header"
	echo $hr
	echo -e "\t\t\t\t   DROP SUBJECT"
	echo $hr
	print_subjects
	read -p "Enter the Subject ID to drop: " DROP_SUBJECT_ID

	if [ -e "$db" ]; then
		awk -v id="$DROP_SUBJECT_ID" -F',' '$1 != id' "$db" >"tmp_db.txt"

		if [ "$(wc -l <"tmp_db.txt")" -eq "$(wc -l <"$db")" ]; then
			clear
			echo "$terminal_header"
			echo -e "${RED}$hr\nSubject with ID $DROP_SUBJECT_ID not found.\n$hr${COLOR_RESET}"
		else
			mv "tmp_db.txt" "$db"
			loading_animation

			clear
			echo "$terminal_header"
			echo "${GREEN}"
			echo $hr
			echo -e "\t\t\tSubject with ID $DROP_SUBJECT_ID dropped successfully."
			echo $hr
			echo "${COLOR_RESET}"

			echo -e "${hr}"
			print_subjects
		fi
	else
		echo "NO SUBJECTS ADDED YET."
	fi

	read -p "Press any key to continue..."
}

# Edit subject
edit_subject() {
	clear
	echo "$terminal_header"
	echo $hr
	echo -e "\t\t\t\t   EDIT SUBJECT"
	echo $hr
	print_subjects
	read -p "Enter the Subject ID to edit: " EDIT_SUBJECT_ID

	if [ -e "$db" ]; then
		awk -v id="$EDIT_SUBJECT_ID" -F',' '$1 == id { print $2, $3, $4 }' "$db" >/dev/null 2>&1
		if [ $? -eq 0 ]; then
			SUBJECT_CODE=$(awk -v id="$EDIT_SUBJECT_ID" -F',' '$1 == id { print $2 }' "$db")
			SUBJECT_NAME=$(awk -v id="$EDIT_SUBJECT_ID" -F',' '$1 == id { print $3 }' "$db")
			SUBJECT_SCHEDULE=$(awk -v id="$EDIT_SUBJECT_ID" -F',' '$1 == id { print $4 }' "$db")

			clear
			echo "$terminal_header"
			echo $hr
			echo -e "\t\t\t\tEDIT SUBJECT DETAILS"
			echo $hr

			read -p "Enter New Subject Code (current: $SUBJECT_CODE): " NEW_SUBJECT_CODE
			read -p "Enter New Subject Name (current: $SUBJECT_NAME): " NEW_SUBJECT_NAME
			read -p "Enter New Subject Schedule (current: $SUBJECT_SCHEDULE): " NEW_SUBJECT_SCHEDULE

			awk -v id="$EDIT_SUBJECT_ID" -v new_code="${NEW_SUBJECT_CODE:-$SUBJECT_CODE}" -v new_name="${NEW_SUBJECT_NAME:-$SUBJECT_NAME}" -v new_schedule="${NEW_SUBJECT_SCHEDULE:-$SUBJECT_SCHEDULE}" -F',' '{if ($1 == id) {$2 = new_code; $3 = new_name; $4 = new_schedule}; OFS=","; print $1, $2, $3, $4}' "$db" >"tmp_db.txt"
			mv "tmp_db.txt" "$db"

			loading_animation

			clear
			echo "$terminal_header"
			echo "${GREEN}"
			echo $hr
			echo -e "\t\t\tSubject with ID $EDIT_SUBJECT_ID edited successfully."
			echo $hr
			echo "${COLOR_RESET}"

			echo -e "${hr}"
			print_subjects
		else
			clear
			echo "$terminal_header"
			echo -e "${RED}$hr\nSubject with ID $EDIT_SUBJECT_ID not found.\n$hr${COLOR_RESET}"
		fi
	else
		echo "NO SUBJECTS ADDED YET."
	fi

	read -p "Press any key to continue..."
}

# Main program
db="db.txt"

if [ ! -e "$db" ]; then
	echo "SUBJECT_ID, SUBJECT_CODE, SUBJECT_NAME, SCHEDULE" >$db
fi

while true; do
	clear
	echo "${terminal_header}"
	read -p $'(1) Add Subject \n(2) Drop Subject \n(3) Edit Subject \n(4) Print Added Subjects \n(5) Exit Program \n\nEnter Operation: ' OPERATION
	case $OPERATION in
	1)
		add_subject
		;;
	2)
		drop_subject
		;;
	3)
		edit_subject
		;;
	4)
		clear
		echo "$terminal_header"
		echo $hr
		echo -e "\t\t\t\tPRINTED ADDED SUBJECTS"
		echo $hr
		print_subjects
		read -p "Press any key to continue..."
		;;
	5)
		echo $'\nTerminating Program'
		exit
		;;
	*)
		echo "${OPERATION} is an invalid input."
		;;
	esac
done
