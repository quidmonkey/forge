<p align="center">
  <a href="https://github.com/quidmonkey/forge">
    <img height="200" width="176" src="https://www.dropbox.com/s/o14iy9b7ng5y5jy/Forge-logo-16color-439x500.png?dl=1">
  </a>
  <p align="center">The task runner for scalable local development</p>
</p>

## What is Forge?

Forge is a task runner intended for larger development teams.

It attempts to solve several problems:

* How do I keep a group of developers in sync?
* How do enable my developers to compile or transpile a codebase that is subject to change at any moment?
* How do I scale my toolchain without having to rewrite my toolchain or force developers to learn a new tool?
* How do I handle developers who don't know their way around a shell?
* How do I minimize the number of commands I must memorize to make my application run?

## Containerization

It's important to mention that Forge is not seeking to replace containerization i.e. Docker, but is intended to complement it. When it comes to env setup and config, containerization is the best solution; but containerization does not solve how to run or develop an application; nor does it deal well with the idiosyncrasies of varying language-based package managers, without resulting to long container initialization times and tedious curation. This is where Forge comes in.

## Install

```
git clone git@github.com:quidmonkey/forge.git ~/.forge
```

When the `install` executable is run, it creates a global `forge` cmd in `/usr/local/bin` for every developer to run on their machine. To setup forge for a project, `cd` in the project root and run `forge install`. This will create a `forge/` directory within the project root. This `forge/` directory contains a `tasks/` directory full of various executable scripts called tasks. These tasks can be written in any language by using a `/usr/bin/env` invocation, and they can do whatever the project requires. No longer does the project need to be chained to a specific toolchain e.g. `maven` or `gulp`. Instead, forge acts a proxy for these tasks, offering a simple interface that only needs to be learned once.

To run a forge task, run:
```shell
forge task
```

To run the default task, run:
```shell
forge
```

To get help, run:
```shell
forge -h
```

To get help for a specific task, run:
```shell
forge task -h
```

To list all available forge tasks, run:
```shell
forge -t
```

Other commands exist to make the development experience easier. Run `forge -h` to find out more.

## Build Notes

If you using forge to generate your build artifact, you will likely not want to run the install script. Instead, clone down the forge repo to your build server and invoke the `forge` executable directly with whatever build tasks you may need e.g. `forge build`.

## Tasks

Dig into the `tasks/` directory of this repo or a project you installed forge into for examples of how to create your own tasks. To create a task, all that is required is to add a task to the `tasks/` directory that includes a `/usr/bin/env` invocation. Whatever the task is named is how the task will be invoked by forge e.g. I create a `tests` task to run my project's specs, and I invoke it using `forge tests`.

The one task that must always exist is the `default` task, which is installed by default. The thinking behind this task is that the entire dev toolchain can be dumped into it, so that all developers must do is run `forge` to begin development on a project.

It is encouraged that task documentation be added for every task. This is done by leaving a multiline comment annotated with `@forge` directives. This documentation is what will be displayed in the terminal when the `forge task -h` cmd is run. See the included examples tasks to see how it is done.

## Version Control

One of the central problems of local development is version control. While Forge does not seek to replace containerization, it does seek to keep to complement and simplify the process of version control during development. Forge exposes a `version_control` function that takes two parameters: a file that lists project dependencies (e.g. `package.json` or `requirements.txt`) and a cmd to execute if the file is stale (e.g. `npm install` or `pip install`. Forge handles version control by caching a copy of the dependencies file that it is given to version control. Each time a `version_control` cmd is run for the file, Forge checks for an associated file of the same name in its cache, and then diffs the current file with the cached version. If a difference is found, the associated cmd is executed to bring the file up-to-date, and then the cache is updated with the new file.

If `version_control` is used within a task that a developer runs all the time i.e. the `default` task, then version control is always exerted on the codebase, and the developer never has to manual check for updates to project dependencies. No more will a developer have to run `npm install` or `pip install` or be told that a new dependency has been added to the codebase. It will all be taken care of seamlessly by forge as it is run. It is encouraged by make use of `version_control` with all dependency files, especially within the `default` task.

See the use of `version_control` in the default task and the `version_control.sh` file for more info.

## Busting the Cache

Sometimes you may want to bust your forge cache. You can do this by passing the `--cachebuster` option. If a filename or filepath is passed with the `--cachebuster` option, Forge will attempt to bust the cache for the given file. Forge creates cache keys based on filepath, so a filepath is preferred - the absolute filepath that is given to the `version_control` function for the file. If Forge can't match based on filepath or a filename it is given, then Forge will loop through each file in the cache and attempt to find a match. If a match is found, the file will be removed. If no match is found, Forge will error out. If no filename or filepath is given, Forge will bust the entire cache.

## Closing Remarks

Forge was created to be scalable and toolchain agnostic. It was written in Bash, because Bash is fast, Bash is flexible enough to run any script in any language, and because Bash is the original JavaScript, being ubiquitous. As most build tools are executed from a shell, it makes the most sense to write a task runner in Bash.

In a nutshell, Forge can be thought of as "the one command to rule them all." Some may argue that they prefer experienced developers to something so simple, but one wonders if they have had the experience of dealing with broken machines on a daily basis, or running a complex set of cmds as a project matures, or having to rewrite the toolchain because the project far out-scaled what was originally envisioned. Forge offers a single interface to gently introduce developers to the cmd line, while offering up the ability for experienced developers to go wild creating tasks and modify Forge to their heart's content (and please submit good ideas as pull requests!).

Now go out, and Forge!

## Api

### bust_cache
```shell
bust_cache filepath
```

Bust the forge cache. Takes an optional filename or filepath that is cached. If a filename or filepath is passed with the `--cachebuster` option, Forge will attempt to bust the cache for the given file. Forge creates cache keys based on filepath, so a filepath is preferred - the absolute filepath that is given to the `version_control` function for the file. If Forge can't match based on filepath or a filename it is given, then Forge will loop through each file in the cache and attempt to find a match. If a match is found, the file will be removed. If no match is found, Forge will error out. If no filename or filepath is given, Forge will bust the entire cache.

This is the function that is run when the `--cachebuster` option is passed.

**Arguments**
* Optional: filename or filepath

**Returns**
* None

Example: `bust_cache "package.json"`

### command_exists

```shell
command_exists cmd
```

Tests if a command exists, and returns true if it does, or false, otherwise.

**Arguments**
* Shell command

**Returns**
* None

Example: `command_exists pwd # => True`

### debug

```shell
debug string
```

Logs a string if `$DEBUG` is set to true by passing the `-d` flag to forge.

**Arguments**
* A string to log for debugging

**Returns**
* None

Example: `debug "Filename: $filename"`

### error

```shell
error string error_code
```

Throw an error by logging a string and terminating the script

**Arguments**
* A string to log as an error
* Optional: exit code (defaults to 1)

**Returns**
* None

Example: `error "Missing $option, unable to run task."`

### get_opt_val

```shell
get_opt_val option cmd_line_args
```

Gets the value for a cmd line option.

**Arguments**
* The option to get the value for
* Cmd line options

**Returns**
* The option's value

Example: `local file=$(get_opt_val "--file" $@); printf "%s" "$file" # => file value i.e. /path/to/some_file`

### get_time

```shell
get_time
```

Get the current timestamp in milliseconds. Be aware that this function can add overhead, especially for MacOS, which does not support millisecond accuracy for the Bash `date` cmd. Or order to achieve millisecond accuracy, MacOS will first check to see if GNU utils have been installed, and if not, must make calls to a system language. It may be better to invoke forge with the `time` cmd e.g. `time forge`.

**Arguments**
* None

**Returns**
* None

Example: `get_time # => 1470796289301`

### has_opt

```shell
has_opt option cmd_line_args
```

Checks to see if an option exists.

**Arguments**
* The option to get the value for
* Cmd line options

**Returns**
* True, if the option exists; false, otherwise

Example: `local has_file=$(has_opt "--file" $@); printf "%s" "$has_file" # => True`

### is_mac_os

```shell
is_mac_os
```

Returns true, if the current OS is MacOS; false, otherwise.

**Arguments**
* None

**Returns**
* True, if the current OS is MacOS; false, otherwise

Example: `[[ is_mac_os ]] && printf "Hello MacOS" # => "Hello MacOS"`

### list_tasks

```shell
list_tasks
```

Lists the available forge tasks in a project.

**Arguments**
* None

**Returns**
* None

Example: `list_tasks`

### log

```shell
log string
```

Logs a string.

**Arguments**
* A string to log for debugging

**Returns**
* None

Example: `log "Something interesting happened"`

### run_task

```shell
run_task task options
```

Runs a task of the same name in the `.forge/tasks` directory. Any Bash task will be sourced, allowing access to the forge api. Any non-Bash task will be executed in a sub-shell. All options invoked with Forge will be passed down to the task that is run.

**Arguments**
* Forge task to run
* Any number of options to pass to the task

**Returns**
* None

Example: `run_task "compile-code" $@`

### task_usage

```shell
task_usage task
```

Prints the documentation for any forge task that has been annotated using the `@forge` directives.

**Arguments**
* Forge task to print usage for

**Returns**
* None

Example: `task_usage "compile-code"`

### usage

```shell
usage
```

Prints the documentation for forge.

**Arguments**
* None

**Returns**
* None

Example: `usage`

### version_control

```shell
version_control file cmd
```

Exert version control on a file by caching a copy of it and comparing the cached version of the file to the current file. If the two are found to be different, run the given cmd, and cache a copy of the current file. The `version_control` function for a specific file will need to be run every time a task is run.

**Arguments**
* File to version control
* Cmd to run if the file is found to be stale

**Returns**
* None

Example: `version_control "$PROJECT_ROOT/package.json" "npm install"`

## Globals

These are the globally available values that are available within Forge:

```shell
readonly PROJECT_ROOT               # the project root where forge is installed in
readonly FORGE_CACHE                # the forge cache directory
readonly FORGE_TASKS                # the tasks directory
readonly DEBUG                      # flag for debug mode
readonly PERF                       # flag for performance mode
```
