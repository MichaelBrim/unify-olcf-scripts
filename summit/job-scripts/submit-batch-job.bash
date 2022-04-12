#!/bin/bash

usage_msg="USAGE ERROR: $0 <job-script> <num-nodes> <num-minutes>"

# check args
[ $# -ne 3 ] && { echo $usage_msg; exit 1; }
js=$1
nn=$2
wt=$3

# capture walltime
export MY_JOB_WALLTIME_MINUTES=$wt
export MY_JOB_WALLTIME_SECONDS=$(( $wt * 60 ))

# run job script
proj=CSC300
[ -n "$UNIFYFS_PROJECT" ] && proj=$UNIFYFS_PROJECT
bsub -P $proj -alloc_flags nvme -nnodes $nn -W $wt $js
