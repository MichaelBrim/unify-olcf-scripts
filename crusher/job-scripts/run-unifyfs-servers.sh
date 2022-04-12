# source this

# launch server infrastructure on all nodes (use $server_cores cores per node)
echo -n "Launching UNIFYFS server infrastructure @ $(date) : "
unifyfs_start_args="-c -S ${UNIFYFS_SHAREDFS_DIR}"
unifyfs_start_cmd="${UNIFYFS_BINDIR}/unifyfs start $unifyfs_start_args"
echo "$unifyfs_start_cmd" 
$unifyfs_start_cmd &> unifyfs.start.out
if [[ $? -ne 0 ]]; then
    echo "JOB ERROR: failed to start UnifyFS servers, checking nodes"
    ${UNIFYFS_SCRIPTS}/check_job_nodes.bash -s
    exit 1
fi

