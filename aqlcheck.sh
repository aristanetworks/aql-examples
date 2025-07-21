#!/usr/bin/env bash

set -e

RESULT=0

for f in $(find . -name "*.aql")
do
    OUT="$($AQLBIN --time-window "5m" --syntax-check "$f" 2>&1)"
    if [ -n "$OUT" ]
    then
        echo "$OUT"
        RESULT=1
    fi
done

exit $RESULT
