# source this

# UNIFYFS job setup
export UNIFYFS_INSTALL=$MY_SCRATCH_DIR/unifyfs-install/$USER/1.0d.pmi2.mpimount
export UNIFYFS_BINDIR=$UNIFYFS_INSTALL/bin
export UNIFYFS_LIBDIR=$UNIFYFS_INSTALL/lib

export LD_LIBRARY_PATH=$UNIFYFS_LIBDIR:$LD_LIBRARY_PATH

# set optional UnifyFS config environ here
export UNIFYFS_SERVER_CORES=$server_cores

mkdir unifyfs-share
export UNIFYFS_SHAREDFS_DIR=$PWD/unifyfs-share

export UNIFYFS_LOG_DIR=$PWD/logs
export UNIFYFS_LOG_ON_ERROR=1
export UNIFYFS_LOG_VERBOSITY=0 # initially disable all logging
#export UNIFYFS_LOG_VERBOSITY=5 # for debugging

export UNIFYFS_LOGIO_SHMEM_SIZE=$(( 65 * $MIB )) # use 65 MiB to ensure 64 MiB of space after logio header
export UNIFYFS_LOGIO_SPILL_SIZE=$(( 5 * $GIB ))
if [[ $unify_mode == "mem" ]]; then
    export UNIFYFS_LOGIO_CHUNK_SIZE=$(( 32 * $KIB ))
    export UNIFYFS_LOGIO_SPILL_SIZE=0 # disable nvm for data storage
elif [[ $unify_mode == "nvm" ]]; then
    export UNIFYFS_LOGIO_CHUNK_SIZE=$(( 8 * $MIB ))
    export UNIFYFS_LOGIO_SHMEM_SIZE=0 # disable shmem for data storage
elif [[ $unify_mode == "span" ]]; then
    export UNIFYFS_LOGIO_CHUNK_SIZE=$(( 2 * $MIB ))
fi
export UNIFYFS_LOGIO_SPILL_DIR=/mnt/bb/$USER

