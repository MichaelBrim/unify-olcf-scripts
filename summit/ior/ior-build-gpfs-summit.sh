INSTALL_PREFIX=/path/to/install/on/gpfs
./configure \
  --prefix=$INSTALL_PREFIX \
  --without-mmap --without-lustre \
  --with-gpfs --with-mpiio --with-posix --with-hdf5
make && make install
