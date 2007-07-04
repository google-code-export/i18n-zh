#!/bin/sh

# git-svn init --trunk=trunk --tags=tags --branches=branches http://svn.foo.org/project

# git-reset --hard trunk
# git-svn rebase

while true; do
    echo "[`date -R`] git-svn fetch ..."
    git-svn fetch

    echo "[`date -R`] git repack ..."
    git repack -d

    echo
    sleep 60
done
