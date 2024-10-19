#!/bin/bash

############ Constants ############

# Define the high-level options
options=(
    "Change Foreground Color"
    "Change Background Color"
    "Bold"
    "Italics"
    "Underline"
    "Strikethrough"
    "Change Text"
    "Print ANSI code"
)

# All possible 4 bit colors by name 
four_bit_color_options=(
    "Black"
    "Red"
    "Green"
    "Yellow"
    "Blue"
    "Magenta"
    "Cyan"
    "White"
    "Bright Black"
    "Bright Red"
    "Bright Green"
    "Bright Yellow"
    "Bright Blue"
    "Bright Magenta"
    "Bright Cyan"
    "Bright White"
)
# All possible 4 bit FOREground colors by value
foreground_4bit_color_values=(
    "30"
    "31"
    "32"
    "33"
    "34"
    "35"
    "36"
    "37"
    "90"
    "91"
    "92"
    "93"
    "94"
    "95"
    "96"
    "97"
)
# All possible 4 bit BACKground colors by value
background_4bit_color_values=(
    "40"
    "41"
    "42"
    "43"
    "44"
    "45"
    "46"
    "47"
    "100"
    "101"
    "102"
    "103"
    "104"
    "105"
    "106"
    "107"
)


############ Globals ############

# Remember State
bold=0  
italics=0
underline=0
strikethrough=0
special=""
background_color=90
foreground_color=37
text="This is your selected text!"

############ Helper Functions ############

# List all options (with value)
display_all(){
    local list_of_options=("$@")
    for i in "${!list_of_options[@]}"; do
        echo -e "$((i + 1)) ${list_of_options[$i]}"
    done
}

# Set up all special options (returns string)
toggle_special(){
    special_char=""
    if [ "$bold" -eq 1 ]; then
        special_char+="1;"
    fi
    if [ "$italics" -eq 1 ]; then
        special_char+="3;"
    fi
    if [ "$underline" -eq 1 ]; then
        special_char+="4;"
    fi
    if [ "$strikethrough" -eq 1 ]; then
        special_char+="9;"
    fi
    echo "${special_char}"
}


############ Main Function ############

menu(){

    # Print the options to the user
    echo "Please select an option from the list below:"
    display_all "${options[@]}"
    echo "q Exit application"

    # Prompt user to select an option
    read -p "Enter the number of your choice (1-10): " choice
    clear

    # Check the user's choice
    case $choice in

        # Foreground Color
        1)
            echo "You chose to Change Foreground Color."
            display_all "${four_bit_color_options[@]}"
            read -p "Enter the number of your choice (1-16): " color_index
            while [[ ! "$color_index" =~ ^[0-9]+$ ]] || [ "$color_index" -lt 1 ] || [ "$color_index" -gt 16 ]; do
                echo "Invalid input. Please enter a valid number."
                read -p "Enter the number of your choice (1-16): " color_index
            done
            clear
            foreground_color=${foreground_4bit_color_values[$((color_index - 1))]}
            echo -e "\033[${special}${background_color};${foreground_color}m${text}\033[0m"
            ;;

        # Background Color
        2)
            echo "You chose to Change Foreground Color."
            display_all "${four_bit_color_options[@]}"

            read -p "Enter the number of your choice (1-16): " color_index
            while [[ ! "$color_index" =~ ^[0-9]+$ ]] || [ "$color_index" -lt 1 ] || [ "$color_index" -gt 16 ]; do
                echo "Invalid input. Please enter a valid number."
                read -p "Enter the number of your choice (1-16): " color_index
            done
            clear
            background_color=${background_4bit_color_values[$((color_index - 1))]}
            echo -e "\033[${special}${background_color};${foreground_color}m${text}\033[0m"
            ;;
        
        # Bold
        3)
            echo -e "You chose to toggle \033[1mbold.\033[0m"
            let bold=$bold^1
            special=$(toggle_special)
            echo -e "\033[${special}${background_color};${foreground_color}m${text}\033[0m"
            ;;
        
        # Italics
        4)
            echo -e "You chose to toggle \033[3mitalics.\033[0m"
            let italics=$italics^1
            special=$(toggle_special)
            echo -e "\033[${special}${background_color};${foreground_color}m${text}\033[0m"
            ;;
        
        # Underline
        5)
            echo -e "\033[4mThis text is Underlined\033[0m"
            let underline=$underline^1
            special=$(toggle_special)
            echo -e "\033[${special}${background_color};${foreground_color}m${text}\033[0m"
            ;;
        
        # Strikethrough
        6)
            echo -e "\033[9mThis text is Strikethrough\033[0m"
            let strikethrough=$strikethrough^1
            special=$(toggle_special)
            echo -e "\033[${special}${background_color};${foreground_color}m${text}\033[0m"
            ;;
        
        # Text
        7)
            read -p "Change the text to:  " text
            ;;
        
        # Print output
        8)
            echo "\033[${special}${background_color};${foreground_color}m${text}\033[0m"
            ;;
        
        # Exit
        q)
            echo "Exiting."
            clear
            exit 0
            ;;
        
        # Error checking
        *)
            echo "Invalid option. Please enter a number between 1-6 or 'q' to exit."
            ;;
    esac

    # Restart loop
    read -p "Continue? [Y,n]" choice
    if [ "$choice" = "n" ]; then
        exit 0
    fi
    clear
}



main(){
    echo -e "\033[1;3;95m$(figlet "ANSI Generator")\033[0m"
    # Loop until user exit
    while true
    do
        menu
    done
}

main
