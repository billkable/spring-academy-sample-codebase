#!/bin/bash

# This script merges the set of commits in the current branch
# onto the commit-set branch.

# The idea is that the commit-set branch contains multiple independent
# sets of commits a sequence according to steps in one or more lab
# exercises.

# The first commit in the sequence will have a commit message of
# "initial commit".

# Each sequence's first commit will be precided by a "clean up" commit
# named "initialize-commit-set" that will drop all files in the repo,
# to prepare for a cherry-pick of the initial commit.
# This is done to allow evolution of scripts and tooling in the initial
# commit that is pulled into the student's view of the codebase as
# provided by a commit set.

# The last commit will be tagged with a one of the following formatted
# tags:
#
#   v0.0.1-pr-{pr number}     -> pr
#   v0.0.2-pre -> prelease tag
#   v0.0.3     -> release tag

# Usage: ./scripts/publish-commit-set.sh <source branch> <tag> <tag annotation msg>

pushd $(dirname $0)/.. > /dev/null

source_branch=$1
tag=$2
tag_annotation=$3

if [[ -z "$source_branch" ]]; then
    echo "No source branch provided."
    echo "Usage: $0 <source branch> <tag> <tag annotation msg>"
    exit 1
fi

if [[ -z "$tag" ]]; then
    echo "No tag provided."
    echo "Usage: $0 <source branch> <tag> <tag annotation msg>"
    exit 1
fi

if [[ -z "$tag_annotation" ]]; then
    echo "No tag annotation message provided."
    echo "Usage: $0 <source branch> <tag> <tag annotation msg>"
    exit 1
fi

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd $SCRIPT_DIR/..

get_current_branch(){
    git rev-parse --abbrev-ref HEAD
}

clean_workspace(){
    git clean -fdx
}

initialize_commit_sets_branch(){
    git reset --hard
    clean_workspace

    git checkout --orphan published-commit-sets
    git rm -rf --cached .
    clean_workspace

    git commit --allow-empty -m'initialize-commit-set'
}

initialize_commit_set(){
    git reset --hard
    clean_workspace

    git checkout published-commit-sets

    git rm -rf --cached .
    clean_workspace

    git commit -m'initialize-commit-set'
}

copy-to-commit-set(){
    for commit in $(git rev-list --reverse $1); do
        git cherry-pick $commit
    done

    git tag -a $2 -m "$3"
}

current_branch=$(get_current_branch)

if [[ -z $(git branch|grep published-commit-sets) ]]; then
    initialize_commit_sets_branch
fi

if [[ $(git rev-list --count published-commit-sets) -gt 1 ]]; then
    initialize_commit_set
else
    clean_workspace
    git checkout published-commit-sets
    clean_workspace
fi

copy-to-commit-set $source_branch $tag

git checkout $current_branch

popd > /dev/null
