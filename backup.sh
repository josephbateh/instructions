#!/bin/bash
cd ~/Code/instructions || exit
date=$(date +%Y-%m-%d)
git checkout main
git add .
git commit -m "${date}"
git push
