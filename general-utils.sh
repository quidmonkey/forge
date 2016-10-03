#!/usr/bin/env bash

##
# Tests if a bash command exists
#
# Arguments:
#   1. Command to test
#
# Returns:
#   True, if the command exists; false, otherwise.
##
command_exists () {
    command -v $1 >/dev/null 2>&1
}

##
# Get a timestamp in milliseconds.
# CAUTION: this function can add overhead,
# especially for MacOS calls. It
# may be better to use the "time" cmd
# and run it against the forge invocation
# i.e. "time forge"
#
# Arguments:
#   None
#
# Returns:
#   Current timestamp
##
get_time () {
    if [[ is_mac_os ]]; then
        # attempt to use the GNU date if coreutils have
        # been installed, otherwise falllback to ruby
        if command_exists gdate; then
            gdate +%s%3N
        else
            ruby -e "puts (Time.now.to_f.round(3)*1000).to_i"
        fi
    else
        date +%s%3N
    fi
}

##
# Initialize forge in a project. This is done by
# running "forge install".
#
# Arguments:
#   1. Forge process root directory
#
# Returns:
#   None
##
install_forge () {
    local forge_process=$1
    log "Installing Forge"
    mkdir -p forge
    cp -Ri $forge_process/tasks forge
    touch .gitignore
    printf "forge/.cache\n" >> .gitignore
    log "Project Setup Complete"
}

##
# Is the current OS MacOS?
#
# Arguments:
#   None
#
# Returns:
#   True, if the current OS is MacOS; false, otherwise.
##
is_mac_os () {
    [[ uname == "Darwin" ]]
}

##
# Run a forge task. Task will be invoked with
# the given cmd line options.
#
# Arguments:
#   1. Task to run
#
# Returns:
#   None
##
run_task () {
    local task=$1; shift
    local options=$@

    log "Starting $task..."

    if [ "$PERF" = true ]; then
        local start_time=$(get_time)
    fi

    # is this a non-bash script?
    if grep -Rq "/usr/bin/env bash" $FORGE_TASKS/$task; then
        # source to allow forge api to be used
        (source $FORGE_TASKS/$task $options)
    else
        # invoke the task in a sub-shell
        (exec $FORGE_TASKS/$task $options)
    fi

    if [[ $? -eq 0 ]]; then
        if [ "$PERF" = true ]; then
            local end_time=$(get_time)
            log "$task completed in $((end_time-start_time)) ms"
        else
            log "$task completed"
        fi
    else
        error "Aborting: Error when running task $task"
        exit 1
    fi
}
