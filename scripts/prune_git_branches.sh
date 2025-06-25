#!/bin/bash

if ! command -v git -v >/dev/null 2>&1; then
    echo "git is not installed"
    exit 1
fi

git fetch -p

for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}')
do
    git branch -D $branch

    if [ $? -ne 0 ]; then
        echo "Failed to delete branch $branch"
    fi
done

exit $?
