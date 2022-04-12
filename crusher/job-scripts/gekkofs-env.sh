# installation prefix
export GKFS_INSTALL=$MY_SCRATCH_DIR/gekkofs-install
export LD_LIBRARY_PATH=$GKFS_INSTALL/lib:$GKFS_INSTALL/lib64:$LD_LIBRARY_PATH
export PATH=$GKFS_INSTALL/bin:$PATH

if [[ -z $MY_JOBDIR ]]; then
    echo "ERROR: please set env var MY_JOBDIR"
else
    jobdir=$MY_JOBDIR
    [[ ! -d $jobdir ]] && mkdir -p $jobdir/gekkofs/logs
fi

# server environment
export GKFS_MOUNTDIR=$jobdir/gekkofs/mount.gekko
export GKFS_ROOTDIR=/mnt/bb/$USER/gekkofs-root.$SLURM_JOBID
export GKFS_HOSTFILE=$jobdir/gekkofs/hosts.$SLURM_JOBID
#export GKFS_LOG_LEVEL=debug
export GKFS_LOG_LEVEL=off

# client environment
export LIBGKFS=$GKFS_INSTALL/lib64/libgkfs_intercept.so
export LIBGKFS_HOSTS_FILE=$GKFS_HOSTFILE
#export LIBGKFS_LOG=all
export LIBGKFS_LOG=none

