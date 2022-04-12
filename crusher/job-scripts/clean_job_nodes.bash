#!/bin/bash
scriptdir=$(dirname $0)

# options
collect_stacks=0
if [ $# -eq 1 ]; then
    #echo "checking option $1"
    [ "$1" == "-s" ] && collect_stacks=1
fi

# check working dir
[ -f $MY_JOB_HOSTFILE ] || { echo "ERROR: missing job hostfile $MY_JOB_HOSTFILE"; exit 1;}

# capture all output from here on
now=$(date +'%F_%T' | sed -e 's/:/-/g')
exec &> nodes.cleanup.$now

server=unifyfsd
if [[ $UNIFYFS_DEBUG == "yes" ]]; then
    server=unifyfsd.real
fi

# do stuff on each host
for host in $(cat $MY_JOB_HOSTFILE); do
    echo "====== $host ======"
    if [ $collect_stacks -eq 1 ]; then
        echo " +++ collecting stacks +++"
        ssh $host $scriptdir/gstack_processes.bash $PWD $server
    fi
    echo " +++ cleaning processes +++"
    ssh $host pkill $server
    echo
    echo " +++ cleaning files +++"
    ssh $host /bin/rm -rfv /tmp/na_sm /tmp/\*unify\* /var/tmp/unify\* /dev/shm/unify\* 
    echo
done
