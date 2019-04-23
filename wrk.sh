#!/bin/bash

echo "start: `date '+%Y-%m-%d %H:%M:%S'`" >> "wrk.log"

d="your base url";

for i in 400.*
do
    wrk -t1 -c500 -d30s -T10s -s "$i" --latency "$d" >> "wrk.log"
done

for i in 100.*
do
    wrk -t1 -c200 -d30s -T10s -s "$i" --latency "$d" >> "wrk.log"
done

echo "end: `date '+%Y-%m-%d %H:%M:%S'`" >> "wrk.log"
echo "\n\n" >> "wrk.log"

