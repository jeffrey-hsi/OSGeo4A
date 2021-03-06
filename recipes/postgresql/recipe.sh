#!/bin/bash

# version of your package
VERSION_postgresql=9.5.3

# dependencies of this recipe
DEPS_postgresql=(iconv)

# url of the package
URL_postgresql=https://ftp.postgresql.org/pub/source/v${VERSION_postgresql}/postgresql-${VERSION_postgresql}.tar.bz2

# md5 of the package
MD5_postgresql=3f0c388566c688c82b01a0edf1e6b7a0

# default build path
BUILD_postgresql=$BUILD_PATH/postgresql/$(get_directory $URL_postgresql)

# default recipe path
RECIPE_postgresql=$RECIPES_PATH/postgresql

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_postgresql() {
  cd $BUILD_postgresql

  # check marker
  if [ -f .patched ]; then
    return
  fi

  try cp $ROOT_PATH/.packages/config.sub $BUILD_postgresql/conftools
  try cp $ROOT_PATH/.packages/config.guess $BUILD_postgresql/conftools
  try patch -p1 < $RECIPE_postgresql/patches/libpq.patch

  touch .patched
}

function shouldbuild_postgresql() {
  # If lib is newer than the sourcecode skip build
  if [ $BUILD_PATH/postgresql/build-$ARCH/src/interfaces/libpq/libpq.so -nt $BUILD_postgresql/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_postgresql() {
  try mkdir -p $BUILD_PATH/postgresql/build-$ARCH
  try cd $BUILD_PATH/postgresql/build-$ARCH
	push_arm
  LIBS="-lgnustl_shared -lsupc++ -lstdc++" \
  LDFLAGS="${LDFLAGS} -L$ANDROIDNDK/sources/cxx-stl/gnu-libstdc++/$TOOLCHAIN_VERSION/libs/${ARCH}" \
  try $BUILD_postgresql/configure --prefix=$STAGE_PATH --host=${TOOLCHAIN_PREFIX} --without-readline
  try make -C src/interfaces/libpq

  #simulate make install
  echo "installing libpq"
  try cp -v $BUILD_postgresql/src/include/postgres_ext.h $STAGE_PATH/include
  try cp -v $BUILD_postgresql/src/interfaces/libpq/libpq-fe.h $STAGE_PATH/include
  try cp -v $BUILD_PATH/postgresql/build-$ARCH/src/include/pg_config_ext.h $STAGE_PATH/include/
  try cp -v $BUILD_PATH/postgresql/build-$ARCH/src/interfaces/libpq/libpq.so $STAGE_PATH/lib/
	pop_arm
}

# function called after all the compile have been done
function postbuild_postgresql() {
	true
}
