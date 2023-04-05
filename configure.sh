#!/usr/bin/env bash
# Copyright (c) 2023 Arista Networks, Inc.  All rights reserved.
# Arista Networks, Inc. Confidential and Proprietary.

set -e

# Add our git config for "git push review"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! grep -q '\[remote "review"\]' $REPO_ROOT/.git/config
then
   REPO_ORIGIN="$(git config --get remote.origin.url)"
   [[ $REPO_ORIGIN != ssh* ]] && echo "Please clone the project via ssh (read http://go/gerrit)" && exit 1
   sed -e "s!@REPO_ORIGIN@!$REPO_ORIGIN!" $REPO_ROOT/gitconfig-review >> $REPO_ROOT/.git/config
fi

# for the benefit of admins
git config remote.origin.push "HEAD:refs/for/dont-push-to-master-by-accident-please-and-thank-you"


# Add the gerrit hook that adds change IDs
gitdir=$(git rev-parse --git-dir)
if [ $USER != "arastra" ]
then
   scp -p -O -P 29418 gerrit.corp.arista.io:hooks/commit-msg ${gitdir}/hooks/
fi