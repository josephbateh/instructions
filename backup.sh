#!/bin/bash
cd /Users/joseph/code/instructions || exit
date=$(date +%Y-%m-%d)
git checkout main
git add .
git commit -m "${date}"
git push
