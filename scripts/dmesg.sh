#! /bin/sh

# default command args
commandArgs="T -l err,warn"
numberRows="1000"
# the command
command="/usr/bin/sudo /bin/dmesg -$commandArgs | tail -$numberRows"
# default timeout before kill this command is 1 second
timeoutsec=1

# help text
helpText="dmesg.sh script to dump kernel message\n"
helpText="$helpText usage: by default dmesg.sh will run \"timeout 1 dmesg.sh -T -l err,warn | tail -$numberRows\"\n"
helpText="$helpText -t specify the timeout of the command in seconds\n"
helpText="$helpText   e.g. \"dmesg.sh -t 2\" will run \"timeout 2 dmesg.sh -T | tail -$numberRows\" i.e. force kill dmesg command in 2 seconds if not finished \n"
helpText="$helpText -a specify the argument for dmesg\n"
helpText="$helpText   e.g. \"dmesg.sh -a T\" will run \"timeout 1 dmesg -T | tail -$numberRows\"\n"

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
command="/usr/bin/sudo /bin/dmesg -$commandArgs | tail -$numberRows"
# full command
fullcommand="/usr/bin/timeout $timeoutsec bash -c \"$command\""
# record time
time=`/bin/date +%s,%Y/%m/%d:%H:%M:%S_%Z%z,``/bin/date -u +%Y/%m/%d:%H:%M:%S`
# debugging script configuration
output=`eval $fullcommand`
#/bin/echo -e "$time,$hostname,$fullcommand on host $hostname" >&2
/bin/echo -e "$time,$hostname,$fullcommand\n----------------------\n$output" >&1

