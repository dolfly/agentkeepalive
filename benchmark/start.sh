#!/bin/bash 

sudo sysctl -w net.inet.ip.portrange.first=12000
sudo sysctl -w net.inet.tcp.msl=1000
sudo sysctl -w kern.maxfiles=1000000 kern.maxfilesperproc=1000000
ulimit -n 100000

NUM=1000
CONCURRENT=60
maxSockets=50

node sleep_server.js &

sleep_server_pid=$!

node proxy.js $maxSockets &

sleep 1

echo "$maxSockets maxSockets, $CONCURRENT concurrent, $NUM requests per concurrent, 5ms delay"

echo "keep alive"
siege -c $CONCURRENT -r $NUM -b http://localhost:1985/k/5

echo "normal"
siege -c $CONCURRENT -r $NUM -b http://localhost:1985/5

sleep 3

kill $sleep_server_pid
kill %