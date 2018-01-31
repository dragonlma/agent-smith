#!/bin/bash

# default command args
numberColumns="8192"
# max number of rows in command output
# top 100 process + 7 header lines = 107
numberRows="107"
# the command arguments
commandArgs="bcn1"
# the command
command="/usr/bin/top"
# maybe also use "ps -eo pid,%cpu,%mem,comm,args --sort=-%cpu | head -n 5"

# default timeout before kill this command is 1 second
timeoutsec=1

# help text
helpText="top.sh script to dump top cpu processes\n"
helpText="$helpText usage: by default top.sh will run \"timeout 1 top -bcn1 -w $numberColumns | head -n $numberRows\"\n"
helpText="$helpText -t specify the timeout of the command in seconds\n"
helpText="$helpText   e.g. \"top.sh -t 2\" will run \"timeout 2 top -bcn1 -w $numberColumns | head -n $numberRows\" i.e. force kill top command in 2 seconds if not finished \n"
helpText="$helpText -a specify the argument for top\n"
helpText="$helpText   e.g. \"top.sh -a -bn1\" will run \"timeout 1 top -bn1 | head -n $numberRows\"\n"
helpText="$helpText -w specify the number of columns for printing out the monitored process arguments\n"
helpText="$helpText   e.g. \"top.sh -w 100\" will run \"timeout 1 top -bcn1 -w 100 | head -n $numberRows\"\n"

# from here below the scripts is petty the same #
while getopts "a:h:r:t:w" opt; do
  case $opt in
    a)
      commandArgs=$OPTARG
      ;;
    r)
      numberRows=$OPTARG
      ;;
    w)
      numberColumns=$OPTARG
      ;;
    h)
      /bin/echo -e "$helpText" >&2
      exit 1
      ;;
    t)
      timeoutsec=$OPTARG
      ;;
    \?)
      /bin/echo -e "Invalid option: -$OPTARG, `/usr/bin/basename "$0"` -h for help on supported options\n" >&2
      /bin/echo -e "$helpText" >&2
      exit 1
      ;;
  esac
done

# get current host name
hostname=`/bin/hostname -a | awk '{print $1}'`" "`/bin/hostname -I | awk '{print $1}'`
# specific command
command="$command -$commandArgs -w $numberColumns | head -n $numberRows"
# full command
fullcommand="/usr/bin/timeout $timeoutsec bash -c \"$command\""
# record time
time=`/bin/date +%s,%Y/%m/%d:%H:%M:%S_%Z%z,``/bin/date -u +%Y/%m/%d:%H:%M:%S`
# debugging script configuration
output=`eval $fullcommand`
#/bin/echo -e "$time,$hostname,$fullcommand on host $hostname" >&2
/bin/echo -e "$time,$hostname,$fullcommand\n----------------------\n$output" >&1

