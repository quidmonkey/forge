#!/bin/bash

# Paths
PROJECT_ROOT=$(pwd)
FORGE_ROOT=$PROJECT_ROOT/.forge
FORGE_CACHE=$FORGE_ROOT/.cache
FORGE_TASKS=$FORGE_ROOT/tasks

# Colors
BLACK='\033[0;30m'
CYAN='\033[0;34m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
YELLOW='\033[0;33m'

# Vars
DEBUG=false
OPTIONS=""
PROJECT="Forge"
TASKS=""