#!/bin/env bash

# og cmdline command: for FBI 2023
#   curl -s "https://ctftime.org/team/159666" | rg "<td>\d{1,2}\.\d{3}</td></tr>"| head -n 50 | awk -F '<td>' '{print $4}' | cut -d'<' -f 1 | sort -nr | head | awk '{ sum +=$1 } END {print sum}'


FBI_url="https://ctftime.org/team/159666"
IUT_GENESIS_url="https://ctftime.org/team/175924"

show_help() {
    echo "Usage: $0 <team> <head> <tail>"
    echo "<team> fbi or iut or url"
    echo "if url is chosen then a promt will appear for input."
    echo "head is the total contests done in that year + after that year"
    echo "tail is the total contest in that year."
    echo "For example,to compute 2022 head will 2022+2023+... and tail will be only 2022"
    echo "Use Case: $0 fbi 50 50"
}

if [ "$#" -ne 3 ]; then
    echo "Error: Incorrect number of arguments."
    show_help
    exit 1
fi

case $1 in
    "iut"|"IUT")
        URL=$IUT_GENESIS_url
        ;;
    "fbi"|"FBI")
        URL=$FBI_url
        ;;
    "url")
        read -p "Enter the CTFtime team URL (format: https://ctftime.org/team/<team_id>): " input_url
        if [[ $input_url =~ https://ctftime.org/team/[0-9]+ ]]; then
            URL=$input_url
        else
            echo "Error: Invalid URL format."
            show_help
            exit 1
        fi
        ;;
    *)
        echo "Error: Invalid team."
        show_help
        exit 1
        ;;
esac

# Main()

# `xargs -n 1` is a nice trick to convert space delimited one line to newline delimited lines.
all_contests_ratings=$(curl -s $URL |rg -o "<td>\d{1,2}\.\d{3}</td></tr>"| xargs -n 1 | cut -d'<' -f2 | cut -d'>' -f2)
# echo $all_contests_ratings

ratingsThatYear=$(echo $all_contests_ratings | xargs -n 1 | head -n $2 | tail -n $3)
# echo $ratingsThatYear

top10results=$(echo $ratingsThatYear | xargs -n 1| sort -nr| head)

# echo $top10results
echo " Ratings this year is : $(echo $top10results| xargs -n 1 | awk '{sum +=$1} END {print sum}')"


# Errors??
# For some teams, CTFtime doesnt compute some ctfs in theri total ctf counts. Thus the ratings might be wrong
# The problme is not in my code. what can i do if the curl output is different.

# I just realised i could just grep out their ratings instead of computing it myself :)
# could have saved a few hours :/
