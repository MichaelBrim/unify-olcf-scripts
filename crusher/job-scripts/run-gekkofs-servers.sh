[ ! -d $GKFS_ROOTDIR ] && mkdir $GKFS_ROOTDIR

srun_args="--exact --overcommit -n$SLURM_NNODES --ntasks-per-node=1 --cpus-per-task $server_cores"
gkfsd_args="-P ofi+tcp -r $GKFS_ROOTDIR -m $GKFS_MOUNTDIR -H $GKFS_HOSTFILE"
echo "Running: srun $srun_args $GKFS_INSTALL/bin/gkfs_daemon $gkfsd_args"
srun $srun_args $GKFS_INSTALL/bin/gkfs_daemon $gkfsd_args &

sleep 5
echo "---- GekkoFS Servers Info ----"
cat $GKFS_HOSTFILE
cp $GKFS_HOSTFILE $GKFS_HOSTFILE.sav
echo "+++++++++++++++++++++++++"

