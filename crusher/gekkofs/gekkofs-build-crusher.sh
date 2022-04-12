# NOTE: This assumes you have followed the step-by-step install instructions on the GekkoFS website.
#       In particular, you should have already downloaded the source for GekkoFS and dependencies and
#       built the dependencies. For further instructions, see 
#       https://storage.bsc.es/projects/gekkofs/documentation/users/building.html#step-by-step-installation

GKFS_INSTALL_PATH=/path/to/gekkofs/install

[ -d build ] && /bin/rm -rf build
mkdir build && cd build

cmake \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DCMAKE_PREFIX_PATH:STRING=$GKFS_INSTALL_PATH \
  -DCMAKE_INSTALL_PREFIX:STRING=$GKFS_INSTALL_PATH \
  -DGKFS_BUILD_TESTS:BOOL=ON \
  .. |& tee $USER-cmake.log
[ $? -eq 0 ] && make |& tee $USER-make.log
[ $? -eq 0 ] && make install |& tee $USER-make-install.log
