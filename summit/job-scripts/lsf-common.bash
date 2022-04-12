# bash script

# USAGE: source $0

export my_job_info="-- INFO --"
export my_job_warn="@@@ WARNING @@@"
export  my_job_err="!!!! ERROR !!!!"

# source this after setting $software and $testname
if [[ -z $software || -z $testname ]]; then
    echo "$my_job_err $0 - please set \$software and \$testname"
    exit 1
fi

# the following avoids an exception thrown by boost::filesystem
export LC_ALL="C"

# LSF environment

export MY_JOBID=$LSB_JOBID

if [[ -n $MYJOBCTL_VERBOSE_ENV ]]; then
    echo "$my_job_info ===================== Job Environment ======================"
    env | grep -v LSB_ | sort
    echo "$my_job_info ============================================================"
    echo
fi

echo "$my_job_info ====================== LSF Job Info ======================="
echo "$my_job_info -------------------- Job Status --------------------"
bjobs -l $MY_JOBID
echo "$my_job_info ----------------------------------------------------"
if [[ -n $MYJOBCTL_VERBOSE_BATCH ]]; then
    echo
    echo "$my_job_info ----------------- LSF Environment ------------------"
    env | grep LSB_ | sort
    env | grep LSF_ | sort
    echo "$my_job_info ----------------------------------------------------"
fi
echo "$my_job_info ============================================================"
echo

# create hostfile
echo "$my_job_info Generating hostfile from LSB_DJOB_HOSTFILE"
hostfile=$PWD/lsf.hosts.$MY_JOBID
uniq $LSB_DJOB_HOSTFILE | fgrep -v batch | fgrep -v login > $hostfile || \
  { echo "$my_job_err Failed to process $LSB_DJOB_HOSTFILE" && exit 1 ; }

# node/proc counts
n_nodes=$(cat $hostfile | wc -l) # using cat avoids filename in output
n_procs=$(( $LSB_DJOB_NUMPROC - 1 )) # minus 1 accounts for launch node core
slots_per_node=$(( $n_procs / $n_nodes ))
export MY_JOB_NUM_NODES=$n_nodes
export MY_JOB_NUM_PROCS_PER_NODE=$slots_per_node
export MY_JOB_NUM_PROCS=$n_procs

# create job directory skeleton structure
jobdir=${MY_SCRATCH_DIR}/jobs/$software/$testname/N${n_nodes}_P${n_procs}/$MY_JOBID
mkdir -p $jobdir || { echo "$my_job_err Failed to mkdir $jobdir" && exit 1 ; }
echo "$my_job_info Changing to job directory $jobdir"
cd $jobdir || { echo "$my_job_err Failed to cd $jobdir" && exit 1 ; }
export MY_JOBDIR=$jobdir

mv $hostfile lsf.hosts
export MY_JOB_HOSTFILE=$PWD/lsf.hosts

echo "$my_job_info Setting up job bin/lib/logs/tmp dirs"
export MY_JOBBIN=$MY_JOBDIR/bin
export MY_JOBLIB=$MY_JOBDIR/lib
export MY_JOBLOG=$MY_JOBDIR/logs
export MY_JOBSHR=$MY_JOBDIR/share
export MY_JOBTMP=$MY_JOBDIR/tmp
mkdir -p $MY_JOBBIN $MY_JOBLIB $MY_JOBLOG $MY_JOBSHR $MY_JOBTMP || \
  { echo "$my_job_err Failed to create job dirs" && exit 1 ; }

export PATH=${MY_JOBBIN}:$PATH
export LD_LIBRARY_PATH=${MY_JOBLIB}:$LD_LIBRARY_PATH

