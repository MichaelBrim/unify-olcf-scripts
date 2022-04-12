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

# SLURM environment

export MY_JOBID=$SLURM_JOBID

if [[ -n $MYJOBCTL_VERBOSE_ENV ]]; then
    echo "$my_job_info ===================== Job Environment ======================"
    env | grep -v SLURM_ | grep -v SBATCH_ | sort
    echo "$my_job_info ============================================================"
    echo
fi

echo "$my_job_info ====================== SLURM Job Info ======================="
squeue --long -j $MY_JOBID
echo "$my_job_info -------------------- Job Status --------------------"
scontrol show job=$MY_JOBID
echo "$my_job_info ----------------------------------------------------"
if [[ -n $MYJOBCTL_VERBOSE_BATCH ]]; then
    echo
    echo "$my_job_info ----------------- SLURM Environment ------------------"
    env | grep SBATCH_ | sort
    env | grep SLURM_ | sort
    echo "$my_job_info ----------------------------------------------------"
fi
echo "$my_job_info ============================================================"
echo

# create hostfile
echo "$my_job_info Generating hostfile"
hostfile=$PWD/slurm.hosts.$MY_JOBID
scontrol show hostnames > $hostfile || \
  { echo "$my_job_err Failed to show hostnames" && exit 1 ; }

# node/proc counts
n_nodes=$SLURM_JOB_NUM_NODES
slots_per_node=$SLURM_CPUS_ON_NODE
n_procs=$(( $slots_per_node * $n_nodes ))
export MY_JOB_NUM_NODES=$n_nodes
export MY_JOB_NUM_PROCS_PER_NODE=$slots_per_node
export MY_JOB_NUM_PROCS=$n_procs

# create job directory skeleton structure
jobdir=${MY_SCRATCH_DIR}/jobs/$software/$testname/N${n_nodes}_P${n_procs}/$MY_JOBID
mkdir -p $jobdir || { echo "$my_job_err Failed to mkdir $jobdir" && exit 1 ; }
echo "$my_job_info Changing to job directory $jobdir"
cd $jobdir || { echo "$my_job_err Failed to cd $jobdir" && exit 1 ; }
export MY_JOBDIR=$jobdir

mv $hostfile slurm.hosts
export MY_JOB_HOSTFILE=$PWD/slurm.hosts

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

