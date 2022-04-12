INSTALL_PREFIX=/path/to/install/on/gpfs
./configure \
  --prefix=$INSTALL_PREFIX \
  --without-mmap --without-lustre --without-gpfs
make && make install
