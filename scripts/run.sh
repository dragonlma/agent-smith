#! /bin/sh
if [ "$#" -ne 1 ]; then
    echo "usage: run.sh \"dir of the script output file\""
    echo "e.g. run.sh /opt/agent-smith"
    exit 1
fi
declare -a SCRIPTS=("top.sh" "netstat.sh" "dmesg.sh")
for s in "${SCRIPTS[@]}"; do
  sh $1"/scripts/"${s} | tee $1"/data/"${s}.out
done
