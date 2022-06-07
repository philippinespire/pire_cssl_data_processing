#!/bin/bash
MESSAGE=$1
git pull
git add --all
git commit -m "$MESSAGE"
git pull
git push
