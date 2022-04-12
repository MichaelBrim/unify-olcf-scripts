module load PrgEnv-gnu
module load gcc/11.2.0
module load cray-python
module load autoconf autoconf-archive automake libtool
module load cmake

# fix for undefined autoconf macros during autogen 
export ACLOCAL_PATH=/usr/share/aclocal:$ACLOCAL_PATH

# allow for finding MPI compilers
alias mpicc=cc
alias mpiCC=CC
alias mpif90=ftn
