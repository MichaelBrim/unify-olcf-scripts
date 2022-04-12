# bash script - source it

if [ -n "$ACLOCAL_PATH" ]; then
    export ACLOCAL_PATH=/usr/share/aclocal:$ACLOCAL_PATH
else
    export ACLOCAL_PATH=/usr/share/aclocal
fi

module load xl
module load cmake
module load python
module load spath

