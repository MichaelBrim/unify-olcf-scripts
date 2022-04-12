#!/bin/bash

if [ $# -ne 2 ]; then
    echo "USAGE ERROR: $0 <jobdir> <app-prefix>"
    exit 1
fi

jobdir=$1
app=$2
h=$(hostname)

for pid in $(pgrep $app); do
    gstack $pid > $jobdir/stack.${app}.${h}.$pid
done
