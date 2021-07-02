#!/bin/bash -ex

# Variables
measurement=internet_speed
baseUri=localhost:8086
downloadSpeed=0
uploadSpeed=0

# Execution
result=$(/usr/bin/speedtest --csv)
downloadSpeed=$(echo "${result}" | awk -F "\"*,\"*" '{print $8}')
uploadSpeed=$(echo "${result}" | awk -F "\"*,\"*" '{print $9}')

# Insert Metrics
curl -s --location --request POST "${baseUri}/write?db=monitoring" \
--header 'Content-Type: text/plain' \
--data-raw "${measurement},type=download value=${downloadSpeed}"

curl -s --location --request POST "${baseUri}/write?db=monitoring" \
--header 'Content-Type: text/plain' \
--data-raw "${measurement},type=upload value=${uploadSpeed}"
