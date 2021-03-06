#!/bin/bash

set -e

DOJOVERSION="1.6.0"

THISDIR=$(cd $(dirname $0) && pwd)
SRCDIR="$THISDIR/../www"
UTILDIR="$SRCDIR/js/dojo-release-${DOJOVERSION}-src/util/buildscripts"
PROFILE="$THISDIR/../profiles/app.js"
CSSDIR="$SRCDIR/css"
DATADIR="$SRCDIR/data"
IMGDIR="$SRCDIR/img"
DISTDIR="$THISDIR/../dist"

if [ ! -d "$UTILDIR" ]; then
  echo "Can't find Dojo build tools -- did you run ./util/setup.sh?"
  exit 1
fi

if [ ! -f "$PROFILE" ]; then
  echo "Invalid input profile"
  exit 1
fi

echo "Using $PROFILE. CSS, DATA and IMG will be copied and JS will be built."

# clean the old distribution files
rm -rf "$DISTDIR"

# i know this sucks, but sane-er ways didn't seem to work ... :(
cd "$UTILDIR"
./build.sh profileFile=../../../../../profiles/app.js releaseDir=../../../../../dist/
cd "$THISDIR"

# copy the css, data and img files
# todo: how to do this better?
cp -r "$CSSDIR" "$DISTDIR/css"
cp -r "$DATADIR" "$DISTDIR/data"
cp -r "$IMGDIR" "$DISTDIR/img"

# copy the index.html and make it production-friendly
cp "$SRCDIR/index.html" "$DISTDIR/index.html"

sed -i -e "s/var _dbpDev = true;//" "$DISTDIR/index.html"
sed -i -e "s/js\/dojo-release-1.6.0-src/js/" "$DISTDIR/index.html"
