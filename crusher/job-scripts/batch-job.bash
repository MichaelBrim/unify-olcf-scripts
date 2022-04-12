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

slurm_walltime() {
    local min=$1
    local hr=$(expr $min / 60)
    if [[ $hr -gt 0 ]]; then
        min=$(expr $min - \( $hr \* 60 \) )
        [[ $min -lt 10 ]] && min="0$min"
        echo "${hr}:${min}:00"
    else
        echo "${min}:00"
    fi
}

# run job script
proj=CSC300
queue=batch
[ -n "$UNIFYFS_PROJECT" ] && proj=$UNIFYFS_PROJECT
[ -n "$UNIFYFS_QUEUE" ] && queue=$UNIFYFS_QUEUE
sbatch -p $queue -A $proj -C nvme -N $nn -t $(slurm_walltime $wt) $js
