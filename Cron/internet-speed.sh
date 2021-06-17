#!/bin/bash -ex

# Variables
measurement=internet_speed
baseUri=localhost:8086
fileName=speedtest.csv
downloadSpeed=0
uploadSpeed=0

# Execution
rm -rf "${fileName}"
speedtest --csv > "${fileName}"
downloadSpeed=$(awk -F "\"*,\"*" '{print $8}' "${fileName}")
uploadSpeed=$(awk -F "\"*,\"*" '{print $9}' "${fileName}")

# Insert Metrics
curl -s --location --request POST "${baseUri}/write?db=monitoring" \
--header 'Content-Type: text/plain' \
--data-raw "${measurement},type=download value=${downloadSpeed}"

curl -s --location --request POST "${baseUri}/write?db=monitoring" \
--header 'Content-Type: text/plain' \
--data-raw "${measurement},type=upload value=${uploadSpeed}"