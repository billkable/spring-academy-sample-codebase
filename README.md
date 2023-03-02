# README

This is a sample project for constructing a codebase that will be used
in Spring Academy hands-on lab exercises.

The idea is to give an optimal student experience interacting with the
codebase on their local machines,
Educates (the current Spring Academy learning platform lab environment),
or potentially another development container oriented environment.

## Goals

Goals are as follows:

-   The student does not have to be git proficient,
    nor even aware of git.

-   The student does not have to be git proficient,
    nor even aware of git,
    unless supporting a learning outcome of a particular lab exercise.

-   For project-based modules comprising multiple lab exercises that
    build on each other,
    the structure of the codebase will:

    -   comprise git commits that will reflect start and solution points
        of each exercise

    -   order of the commits reflect the sequence of the project flow

    -   with exception of a root commit,
        only start and solution commits are present in a branch being
        exposed to the student (either as a local or remote codebase).

-   For non-project based modules where lab exercises use code that
    does not build on each other,
    the structure of the codebase may only include a start and solution
    point as a pair of commits.

-   Each exercise solution point *should* provide a minimal
    automatable validation (for example, integration test).
    The idea is for both student validation,
    as well as CI pipeline automation that the code is correct.

## Views of the codebase

What makes this codebase different from mainstream application
codebases is that the codebase provided to the student is specific to
the sequence of exercises according to a module or learning path.

The authors' view of changes to a codebase according to the following
scenarios:

1.  Brand new code for a new exercise
1.  Amending code for an existing exercise
1.  Version updates for code dependencies
    (for example, spring boot patch or minor level updates)

Changes for #2 and 3 will require rebasing to get the codebase to the
students' view of the code.

## Tracking versions

The codebase must support at minimum of the number of versions according
to environments,
but ideally should support ability to go back in time to see what
the students' view a codebase looks like for a given release version.

There are a few different versioning scenarios to consider:

1. Development inner loop
1. PR flow
1. Pre-prod releases
1. Production releases

Scenarios #1 and 2 are accomodated via topic / pr branch,
where the author can rebase freely.

For scenarios 3 and 4,
pre-production and prod releases are merged back to main and tagged with
a release branch,
*ensuring the students' commit history sequence is preserved*.
