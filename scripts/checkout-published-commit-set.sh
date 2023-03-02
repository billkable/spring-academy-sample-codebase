#!/bin/bash

# This script extracts a source_tagged set of commits from the
# published-commit-sets branch to a new branch.

# Usage: ./scripts/checkout-published-commit-set.sh <target_branch> <source_tag>

pushd $(dirname $0)/.. > /dev/null

target_branch=$1
source_tag=$2

if [[ -z "$target_branch" ]]; then
    echo "No target branch provided."
    echo "Usage: $0 <target branch> <source_tag>"
    exit 1
fi

if [[ -z "$source_tag" ]]; then
    echo "No source tag provided."
    echo "Usage: $0 <target_branch> <source_tag>"
    exit 1
fi

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd $SCRIPT_DIR/..

hard_clean(){
    git reset --hard
    git clean -fdx
}

create_new_branch(){
    branch=$1

    hard_clean
    git checkout --orphan $branch

    git rm -rf --cached .
    hard_clean
}

find_first_commit_for_set(){
    tag=$1

    for commit in $(git rev-list $tag); do
        commit_message=$(git log -1 --pretty=%B $commit)

        if [[ $commit_message == "<initial-commit>"* ]]; then
            echo $commit
            break
        fi
    done
}

extract_commits(){
    commit=$1
    tag=$2

    git cherry-pick $commit

    for commit in $(git rev-list --reverse ${commit}..${tag}); do
        echo "cherry picking $commit $(git log -1 --pretty=%B $commit))"
        git cherry-pick $commit
    done
}

create_new_branch $target_branch
first_commit=$(find_first_commit_for_set $source_tag)
extract_commits $first_commit $source_tag