#!/bin/bash
while true; do
    echo "hello `date -u`" > /tmp/inotify_test/abc;
    sleep 1;
done
