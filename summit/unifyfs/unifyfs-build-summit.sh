# you should source 'load-modules-summit.sh' first and make sure Spack environment is loaded
INSTALL_PREFIX=/path/to/install/on/gpfs
GOTCHA_ROOT=/path/to/gotcha/install/from/spack/env
SPATH_ROOT=$OLCF_SPATH_ROOT
./configure \
  --prefix=$INSTALL_PREFIX \
  --enable-mpi-mount \
  --with-gotcha=$GOTCHA_ROOT \
  --with-spath=$SPATH_ROOT
make && make install
