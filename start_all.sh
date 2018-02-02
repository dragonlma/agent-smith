export CMX_ENDPOINT=ws://localhost:9001
export AGENT_HOME=/opt/agent-smith
#nohup nc -lk 8080 &
python ${AGENT_HOME}/agent/fstatWsWatcher.py ${AGENT_HOME}/data ${CMX_ENDPOINT} &> /tmp/watcher.log & while ((1)); do ${AGENT_HOME}/scripts/run.sh ${AGENT_HOME}; sleep 3; done
