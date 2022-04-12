UNIFYFS_ROOT=/path/to/unifyfs/install
INSTALL_PREFIX=/path/to/install/on/gpfs
./configure \
  --prefix=$INSTALL_PREFIX \
  --without-mmap --without-lustre --without-gpfs --with-unifyfs \
  LDFLAGS=-L$UNIFYFS_ROOT/lib
make && make install
