#!/bin/bash

## This script is used to test all labeled commits in the current branch,
## Usage: ./test-all-labeled-commits.sh

BUILD_TOOL=$1

if [ -z "$BUILD_TOOL" ]; then
    echo "Please specify the build tool, e.g. ./test-all-labeled-commits.sh gradle|maven"
    exit 1
elif [ "$BUILD_TOOL" != "gradle" ] && [ "$BUILD_TOOL" != "maven" ]; then
    echo "Please specify the build tool, e.g. ./test-all-labeled-commits.sh gradle|maven"
    exit 1
fi

maven() {
    echo "testing with maven"
    ./mvnw clean install -DskipTests
    ./mvnw test
}

gradle() {
    echo "testing with gradle"
    ./gradlew clean build
}

current_branch=$(git rev-parse --abbrev-ref HEAD)

for commit in $(git rev-list --reverse HEAD); do
    git checkout $commit

    current_commit=$(git log -1 --pretty=oneline|grep "<"|grep ">")

    if [ ! -n "$current_commit" ]; then
        echo "skip commit: $current_commit.  It is not a labeled commit."
        continue
        $build_status=0
    elif [[ $current_commit == *"<initial-commit>"* ]]; then
        echo "skip commit: $current_commit.  It is an initial commit with no java projects."
        continue
        $build_status=0
    else
        echo "testing commit: $current_commit."
        $BUILD_TOOL
        build_status=$?

        if [ $build_status -ne 0 ]; then
            break
        fi
    fi
done

# Checkout to original branch.
git checkout $current_branch
git reset --hard

exit $build_status