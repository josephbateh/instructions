#!/bin/bash -x

# Print Date
date

# Variables
measurement=internet_status
baseUri=localhost:8086

# Ping Google
ping -c 1 google.com
google=$?

# Ping Wikipedia
ping -c 1 wikipedia.com
wikipedia=$?

# Determine Status
successBool=true
if [[ $google != 0 && $wikipedia != 0 ]]; then
  successBool=false
  echo "FAILED."
  echo "Exit Code: ${google}"
fi

# Insert Metric
curl -s --location --request POST "${baseUri}/write?db=monitoring" \
--header 'Content-Type: text/plain' \
--data-raw "${measurement},success=${successBool} value=1"