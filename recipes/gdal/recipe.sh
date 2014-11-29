#!/bin/bash

# version of your package
VERSION_gdal=1.11.1

# dependencies of this recipe
DEPS_gdal=(iconv)

# url of the package
URL_gdal=http://download.osgeo.org/gdal/$VERSION_gdal/gdal-${VERSION_gdal}.tar.gz

# md5 of the package
MD5_gdal=7555f55855f613be49e6508eed0ac3fa

# default build path
BUILD_gdal=$BUILD_PATH/gdal/$(get_directory $URL_gdal)

# default recipe path
RECIPE_gdal=$RECIPES_PATH/gdal

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gdal() {
  cd $BUILD_gdal

  # check marker
  if [ -f .patched ]; then
    return
  fi

  try cp $BUILD_PATH/tmp/config.sub $BUILD_gdal
  try cp $BUILD_PATH/tmp/config.guess $BUILD_gdal

  touch .patched
}

# function called to build the source code
function build_gdal() {
  # try mkdir -p $BUILD_PATH/gdal/build
  try cd $BUILD_gdal
	push_arm
  printenv
  LIBS="-lgnustl_shared -lsupc++ -lstdc++" \
    try ./configure \
    --prefix=$DIST_PATH \
    --host=arm-linux-androideabi \
    --with-sqlite3=$DIST_PATH \
    --with-geos=$DIST_PATH/bin/geos-config
  try make #-j$CORES
  try make install -j$CORES
	pop_arm
}

# function called after all the compile have been done
function postbuild_gdal() {
	true
}