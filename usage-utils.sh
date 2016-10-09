#!/usr/bin/env bash

##
# Prints the current forge version
#
# Arguments:
#   1. Forge process root directory
#
# Returns:
#   None
##
forge_version () {
    local forge_process=$1
    printf "Forge v%s\n" "$(cat $forge_process/.forge-version)"
}

##
# Print the usage for forge install
#
# Arguments:
#   None
#
# Returns:
#   None
##
install_usage () {
    printf "
        USAGE:
            forge install

        NOTES:
            This will initialize a project with the .forge/ directory.
            The directory this cmd is run in will be where .forge/ installs,
            and it will be considered the root directory of the project.
            The .forge/ directory will initialize with the example forge tasks.
    \n"
}

##
# List available forge tasks
#
# Arguments:
#   None
#
# Returns:
#   None
##
list_tasks () {
    printf "\n    Forge Tasks:\n\n"
    for filepath in $FORGE_TASKS/*; do
        t=${filepath##*/}
        printf "        - $t\n"
    done
    printf "\n"
}

##
# Print the usage for a specific task by searching
# for multiline comments with @forge anotations
# and printing the contents between them.
#
# Arguments:
#   1. Task to get usage for
#
# Returns:
#   None
##
task_usage () {
    local task_help=$(sed '/@forge/,/@forge/!d;//d' $1)

    if [[ -z $task_help ]]; then
        error "Aborting: Unable to find @forge help docs for task ${1##*/}"
    fi

    printf '\n%s\n\n' "$task_help"
}

##
# Print forge update usage
#
# Arguments:
#   None
#
# Returns:
#   None
##
update_usage () {
    printf "
        USAGE:
            forge update

        NOTES:
            This will install the latest release of forge.
    \n"
}

##
# Print forge usage
#
# Arguments:
#   None
#
# Returns:
#   None
##
usage () {
    printf "
        USAGE:
            forge task options

        SETUP A PROJECT:
            Run \"forge install\" in the project root to initialize forge.

        OPTIONS:
            -d --debug      Enable debug mode
            -h --help       Show help
            -p --perf       Show timestamps
            -t --tasks      List all tasks
            -v --version    List the current forge version
            --cachebuster   Bust the forge cache: takes an optional filepath to bust

        NOTES:
            The desired task name must be the first arg.
            If no task is given, the default task will be used.

            All options will be passed down to the invoked task.

        EXAMPLES:
            Run default task:
                forge

            List all tasks:
                forge -t

            Run a task:
                forge task

            Get help for a specific task:
                forge task -h

            Bust the forge cache:
                forge --cachebuster

            Bust the forge cache for a specific file:
                forge --cachebuster filepath
    \n"
}
