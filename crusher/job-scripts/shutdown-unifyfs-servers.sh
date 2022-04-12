# source this

# cleanup
echo
echo -n "Cleaning up @ $(date) : "
unifyfs_term_args=""
stop_cmd="${UNIFYFS_BINDIR}/unifyfs terminate $unifyfs_term_args"
echo "$stop_cmd"
$stop_cmd &> unifyfs.terminate.out
sleep 5 

