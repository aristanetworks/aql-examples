#!/bin/bash

set -e


for rev in "$(find "${SOURCEDIR}/revisions" -mindepth 1 -name "revision*" -exec basename {} \;)"
do
    REVISIONNUM=$(echo "$rev" | sed -e "s/^revision//")
    $SPHINX --html-define project="CloudVision Advanced Query Language - Revision $REVISIONNUM" -c "$SOURCEDIR" -a -E "$SOURCEDIR/revisions/$rev" "$BUILDDIR/$rev"
    mkdir -p "$SOURCEDIR/revisions/$rev/doc/images" # to avoid failures if images does not exist
    cp -r "$SOURCEDIR/revisions/$rev/doc/images" "$BUILDDIR/$rev/images"
done
