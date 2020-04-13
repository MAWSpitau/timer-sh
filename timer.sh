#!/bin/bash

# Quick'n'Dirty Timer
# MAWSpitau 2018-05-17
# Idee von https://superuser.com/questions/611538/is-there-a-way-to-display-a-countdown-or-stopwatch-timer-in-a-terminal

# Hier auskommentieren für debugging.
# DEBUG="=====>>>- DEBUGGING:"
# USAGE:
# [[ $DEBUG ]] && echo ${DEBUG} "Nachricht"
figlet=`which figlet`
[[ -f $figlet ]] && endetxt="figlet -c" || endetxt="echo"


# Progressbar credits to:
# https://github.com/fearside/ProgressBar/

# 1. Create ProgressBar function
# 1.1 Input is currentState($1) and totalState($2)
function ProgressBar {
# Process data
     let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
# Build progressbar string lengths
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:
# 1.2.1.1 Progress : [########################################] 100%
printf "\r$title: [${_fill// /▋}${_empty// /-}] ${_progress}%% - $(date -u --date @$(($date1 - `date +%s` )) +%H:%M:%S)"
}

clear

[[ -z ${1} ]] && exit 1;

alarmton=/home/marcel/Dropbox/3_audio/3+1_bell.ogg
sekunden=${1}
date1=$((`date +%s` + $sekunden));

[[ ! -z ${2} ]] && title=${2} || title="Timer"

while [ "$date1" -ge `date +%s` ]; do
	vergangenezeit=$((sekunden-(date1-`date +%s`)))
	ProgressBar ${vergangenezeit} ${sekunden}
    # printf " - "$(date -u --date @$(($date1 - `date +%s` )) +%H:%M:%S);
	sleep 0.5
done

echo " "
echo " "
echo " "
$endetxt $title

cvlc ${alarmton} 2>&1 > /dev/null
