#!/bin/bash
while true; do
    curl -d "hello `date -u`" -m 1 -s -S -X POST http://localhost:8080/pubsub?tenant=agent-smith > /dev/null;
    sleep 1;
done
