#!/bin/bash

# default command args
commandArgs="napt"
# max number of rows in command output
# top 20000 result + 2 header lines = 20002
numberRows="20002"
# the command
command="/usr/bin/sudo /bin/netstat"
# default timeout before kill this command is 1 second
timeoutsec=1

# help text
helpText="netstat.sh script to dump netstat on tcp connections, without resolving full host dns, need sudo to identify all process name pid\n"
helpText="$helpText usage: by default netstat.sh will run \"timeout 1 netstat -napt | head -$numberRows\"\n"
helpText="$helpText -t specify the timeout of the command in seconds\n"
helpText="$helpText   e.g. \"netstat.sh -t 2\" will run \"timeout 2 netstat -napt | head -$numberRows\" i.e. force kill netstat command in 2 seconds if not finished \n"
helpText="$helpText -a specify the argument for netstat\n"
helpText="$helpText   e.g. \"netstat.sh -a nap\" will run \"timeout 1 netstat -nap | head -$numberRows\"\n"

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
command="$command -$commandArgs | head -$numberRows"
# full command
fullcommand="/usr/bin/timeout $timeoutsec bash -c \"$command\""
# record time
time=`/bin/date +%s,%Y/%m/%d:%H:%M:%S_%Z%z,``/bin/date -u +%Y/%m/%d:%H:%M:%S`
# debugging script configuration
output=`eval $fullcommand`
#/bin/echo -e "$time,$hostname,$fullcommand on host $hostname" >&2
/bin/echo -e "$time,$hostname,$fullcommand\n----------------------\n$output" >&1

