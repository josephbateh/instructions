#!/bin/bash
cd /Users/joseph/code/instructions
date=$(date +%Y%m%d)
git checkout master
git add .
git commit -m $date
git push