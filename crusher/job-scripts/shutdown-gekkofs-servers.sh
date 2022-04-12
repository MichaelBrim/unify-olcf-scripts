# terminate the gkfs_daemon job step
stepid=$( squeue --steps -j $SLURM_JOBID | fgrep gkfs_d | awk '{print $1}' )
scancel -s INT $stepid

# use the following to gather per-node logs
#srun -N$SLURM_NNODES --ntasks-per-node=1 /bin/bash -c 'mkdir -p /gpfs/alpine/proj-shared/csc300/crusher/gekkofs-test/job.$SLURM_JOBID/gekkofs/logs/`hostname`; cp /tmp/gkfs* /gpfs/alpine/proj-shared/csc300/crusher/gekkofs-test/job.$SLURM_JOBID/gekkofs/logs/`hostname`/'
