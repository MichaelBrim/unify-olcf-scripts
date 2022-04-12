#! /bin/bash -l

#module load hdf5

# set necessary environment
export MY_SCRATCH_DIR=/gpfs/alpine/csc300/proj-shared/crusher
export UNIFYFS_PROJDIR=/ccs/proj/csc300
export UNIFYFS_SCRIPTS=/ccs/proj/csc300/scripts/unifyfs/crusher/paper_scripts

[[ ! -d $UNIFYFS_SCRIPTS ]] && \
  { echo "ERROR: scripts directory $UNIFYFS_SCRIPTS is missing"; exit 1; }


# Use shared file or file-per-process?
ior_file_mode=shared

basetest=ior-${ior_file_mode}

#unify_mode=mem
#unify_mode=span
unify_mode=nvm

software=unifyfs-gekkofs-${basetest}-${unify_mode}
testname=crusher-perf

TEST_DIR=$MY_SCRATCH_DIR/gekkofs-test

# SLURM job setup (creates job dir and cd's to it)
source ${UNIFYFS_SCRIPTS}/slurm-common.bash
# NOTE: current working directory is now $MY_JOBDIR

total_nodes=$MY_JOB_NUM_NODES
total_cores=64
server_cores=4

# Application job setup (sets app_exe, app_args, ...)
app_cores=$(( $total_cores - $server_cores ))
app_nodes=$total_nodes
app_ppn=8
#app_ppn=16

KIB=$(( 2 ** 10 ))
MIB=$(( 2 ** 20 ))
GIB=$(( 2 ** 30 ))


# capture environment after all job setup completed
env &> job.environ

# Run things

fs_types="gekkofs unifyfs"
for fs in $fs_types; do
    # set IOR_EXE
    IOR_INSTALL=$TEST_DIR/ior-3.3.0+unifyfs/build/$fs/install
    export IOR_EXE=$IOR_INSTALL/bin/ior

    # start FS servers
    source $UNIFYFS_SCRIPTS/$fs-env.sh
    source $UNIFYFS_SCRIPTS/run-$fs-servers.sh
    env &> $fs.environ

    # show active job steps
    echo "At $(date), listing job steps : "
    squeue -s -j $SLURM_JOBID

    # run IOR tests
    source $UNIFYFS_SCRIPTS/run-ior-split-rdwr.sh
    
    # show active job steps
    echo "At $(date), listing job steps : "
    squeue -s -j $SLURM_JOBID

    # terminate servers
    source $UNIFYFS_SCRIPTS/shutdown-$fs-servers.sh
    source $UNIFYFS_SCRIPTS/$fs-env-clean.sh

    sleep 15
    
    # show active job steps
    echo "At $(date), listing job steps : "
    squeue -s -j $SLURM_JOBID
done

# cleanup state on nodes
${UNIFYFS_SCRIPTS}/clean_job_nodes.bash

echo "All done @ $(date)"

