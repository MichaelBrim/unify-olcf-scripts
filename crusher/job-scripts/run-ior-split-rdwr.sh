# source this

if [[ -z $IOR_EXE ]]; then
    echo "ERROR: Please set env var IOR_EXE"
else
    ior_exe=$IOR_EXE

    # set run config
    ior_ppn=8
    ior_nprocs=$(( $ior_ppn * $SLURM_NNODES ))
    ior_nnodes=$SLURM_NNODES
    
    ior_chunksz=8M
    ior_blocksz=512M
    
    ior_iters=5
    
    if [[ -n $GKFS_MOUNTDIR ]]; then
        ior_datadir=$GKFS_MOUNTDIR
    else
        ior_datadir="/unifyfs"
    fi
    runtag=$( basename $ior_datadir )

    run_iters="1 2 3"
    #run_iters="1"

    # IOR write phase
    for run_iter in $run_iters; do
    for ior_mode in POSIX MPIIO; do
    
        # IOR arguments
        # -a <mode>     : IO mode
        # -c            : use collective IO
        # -F            : use file-per-process
        # -v -v         : more verbose
        # -m -i <nfile> : multi-file
        # -e -w         : do write phase, fsync after phase
        # -k            : keep file after test completes
        # -t <size>     : transfer size (i.e., data size per write/read op)
        # -b <size>     : block size (i.e., contiguous data size per process)
        ior_args="-a $ior_mode -v -v -m -i $ior_iters -e -w -k -t $ior_chunksz -b $ior_blocksz"
        if [[ $ior_file_mode == "shared" ]]; then
            if [[ $ior_mpi_mode == "collective" ]]; then
                ior_args="$ior_args -c"
            fi
        else # "fpp"
            ior_args="$ior_args -F"
        fi
        
        ior_outfile="-o $ior_datadir/testfile.$ior_mode.$run_iter"
        ior_args="$ior_args $ior_outfile"
        
        #srun_overlap="--exact --overlap"
        srun_preload=""
        if [[ -n $LIBGKFS ]]; then 
            srun_preload="--export=ALL,LD_PRELOAD=$LIBGKFS"
        fi
        srun_args="$srun_preload -N $ior_nnodes -n $ior_nprocs -c2 --gpus-per-task=1 --gpu-bind=closest"
        
        echo "==============================================================================="
        echo
        echo "Running: srun $srun_args $ior_exe $ior_args"
        echo
        srun $srun_args $ior_exe $ior_args |& tee ior-run.wr.log.$ior_mode.$run_iter.$runtag
        echo
        echo "==============================================================================="
        echo
        echo
        
        sleep 5
    
    done #ior_mode
    done #run_iter

    # IOR read phase
    for run_iter in $run_iters; do
    for ior_mode in POSIX MPIIO; do
    
        # IOR arguments
        # -a <mode>     : IO mode
        # -c            : use collective IO
        # -F            : use file-per-process
        # -v -v         : more verbose
        # -m -i <nfile> : multi-file
        # -r            : do read phase
        # -t <size>     : transfer size (i.e., data size per write/read op)
        # -b <size>     : block size (i.e., contiguous data size per process)
        ior_args="-a $ior_mode -v -v -m -i $ior_iters -r -t $ior_chunksz -b $ior_blocksz"
        if [[ $ior_file_mode == "shared" ]]; then
            if [[ $ior_mpi_mode == "collective" ]]; then
                ior_args="$ior_args -c"
            fi
        else # "fpp"
            ior_args="$ior_args -F"
        fi
        
        ior_outfile="-o $ior_datadir/testfile.$ior_mode.$run_iter"
        ior_args="$ior_args $ior_outfile"
        
        #srun_overlap="--exact --overlap"
        srun_preload=""
        if [[ -n $LIBGKFS ]]; then 
            srun_preload="--export=ALL,LD_PRELOAD=$LIBGKFS"
        fi
        srun_args="$srun_preload -N $ior_nnodes -n $ior_nprocs -c2 --gpus-per-task=1 --gpu-bind=closest"
        
        echo "==============================================================================="
        echo
        echo "Running: srun $srun_args $ior_exe $ior_args"
        echo
        srun $srun_args $ior_exe $ior_args |& tee ior-run.rd.log.$ior_mode.$run_iter.$runtag
        echo
        echo "==============================================================================="
        echo
        echo
        
        sleep 5
    
    done #ior_mode
    done #run_iter
fi
