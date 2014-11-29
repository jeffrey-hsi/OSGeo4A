OSGeo4A
==========

This provides a set of scripts to build opensource geo tools for android.

Build instructions
-----------

Create a file config.conf in the root folder with the following content

```sh
export ANDROIDSDK="/path/to/android-sdk"
export ANDROIDNDK="/path/to/android-sdk"
export ANDROIDNDKVER=r10c
export ANDROIDAPI=14
export CORES=8
export QTSDK="/path/to/qt/sdk/Qt5.4.0/5.4"

```

Call
```sh
./distribute.sh d=qgis m='qgis'
```