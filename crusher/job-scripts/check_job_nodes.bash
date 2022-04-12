#!/bin/bash
scriptdir=$(dirname $0)

# options
collect_stacks=0
if [ $# -eq 1 ]; then
    #echo "checking option $1"
    [ "$1" == "-s" ] && collect_stacks=1
fi

# check working dir
[ -f $MY_JOB_HOSTFILE ] || { echo "ERROR: run me with job directory as cwd (missing job hostfile $MY_JOB_HOSTFILE)"; exit 1;}

# capture all output from here on
now=$(date +'%F_%T' | sed -e 's/:/-/g')
exec &> nodes.status.$now

server=unifyfsd
if [[ $UNIFYFS_DEBUG == "yes" ]]; then
    server=unifyfsd.real
fi

# do stuff on each host
for host in $(cat $MY_JOB_HOSTFILE); do
    echo "====== $host ======"
    echo " +++ files +++"
    ssh $host ls -l /tmp/na_sm /tmp/\*unifyfs\* /var/tmp/\*unifyfs\* /dev/shm/\*unifyfs\* $UNIFYFS_LOGIO_SPILL_DIR/
    echo
    echo " +++ processes +++"
    ssh $host ps aux | fgrep $USER
    echo
    if [ $collect_stacks -eq 1 ]; then
        ssh $host $scriptdir/gstack_processes.bash $PWD $server
    fi
done
