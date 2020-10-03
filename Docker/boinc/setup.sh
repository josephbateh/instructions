#!/bin/bash -ex
echo "Username"
read username

echo "Password"
read password

docker-compose up -d

docker exec boinc boinccmd --passwd ${password} --join_acct_mgr http://bam.boincstats.com/ ${username} ${password}
docker exec boinc boinccmd --passwd ${password} --acct_mgr sync