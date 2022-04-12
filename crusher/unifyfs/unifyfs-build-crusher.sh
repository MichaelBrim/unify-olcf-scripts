# you should source 'load-modules-gcc11-crusher.sh' first and make sure Spack environment is loaded
GOTCHA_ROOT=/path/to/gotcha/install/from/spack/env
SPATH_ROOT=/path/to/spath/install/from/spack/env
INSTALL_PREFIX=/path/to/install/on/gpfs
./configure \
  --prefix=$INSTALL_PREFIX \
  --with-gotcha=$GOTCHA_ROOT \
  --with-spath=$SPATH_ROOT \
  --enable-pmi \
  --enable-mpi-mount \
  MPICC=cc MPICXX=CC MPIFC=ftn
make && make install
