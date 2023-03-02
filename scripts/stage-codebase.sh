#!/bin/bash
set -e

# Stage the codebase

# This script is used to checkout the codebase to the commit that
# corresponds to the lesson label from the commit message.

# Note this file is meant to generalize the staging of the codebase via
# a provided LESSON_LABEL environment variable.
# there are no explicit parameters for this script to maximize the
# decoupling of the lesson content from the staging script.

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd $SCRIPT_DIR/..

lesson_label=$1

if [[ -z "$lesson_label" ]]; then
    lesson_label=$LESSON_LABEL
    if [[ -z "$lesson_label" ]]; then
        echo "No lesson label provided."
        exit 1
    fi
fi

get_sha_for_lesson_label() {
    git log --format=format:%H --grep "$lesson_label"
}

checkout_to_start_commit() {
    if [[ ! -z "$lesson_label" ]]; then
        lesson_sha=$(get_sha_for_lesson_label)
        if [[ -z "$lesson_sha" ]]; then
            echo "LESSON_LABEL '$lesson_label' is not mapped to commit for this workshop."
        else
            echo "going to do the checkout"
            git checkout $lesson_sha
        fi
    else
        echo "No lesson label provided."
    fi
}

checkout_to_start_commit

# TODO if needed, replace external configuration parameters