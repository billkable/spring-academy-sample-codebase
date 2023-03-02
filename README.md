# README

This project provides you some basic tools to get you started:

1.  Test Script (`scripts/test-all-labeled-commits.sh`) to test all
    labeled commits with either gradle or maven build tools

1.  A github workflow to test all labeled commits with either gradle or
    maven build tools (`.github/workflows/test-all-labeled-commits.yml`).
    It works with commits and pull requests to `main` branch.
    You change move it to different branch if you want.

1.  Codebase Staging Script (`scripts/stage-codebase.sh`) to set your
    codebase to a specific labeled commit
    (according to a lab exercise or lesson).

    It works by passing a lesson label that is present on the commit
    message you want to spin your codebase workspace (HEAD) to:

    `./scripts/stage-codebase.sh "<exercise-solution>"`
