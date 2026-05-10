#!/bin/bash

# Fetch the weather data (Temperature and Condition only, no icon)
data=$(curl -s 'https://wttr.in/Hackensack,NJ?format=%t|%C')

# If the website is down or returns HTML, show an error message
if [[ $data == *"html"* ]] || [[ -z $data ]]; then
    echo "Weather Unavailable"
    exit 1
fi

# Split the data into pieces and strip the '+' from the temperature
temp=$(echo "$data" | cut -d'|' -f1 | sed 's/+//g')
cond=$(echo "$data" | cut -d'|' -f2)

# Print the final minimalist output
echo "$temp $cond"