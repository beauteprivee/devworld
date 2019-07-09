#!/usr/bin/env bash

###########################
# Shell entry point for the project.
# This file detects different variables
# and based on detected environment, sets the context to install, update or run the applications.

# @category Application
# @package  Beauteprivee Devworld
# @author   Amir Moradi https://www.linkedin.com/in/amirhmoradi
# @license  GNU GPLv3 (See LICENSE.md)
# @link     http://www.beauteprivee.com/
###########################

if [ -z ${DEVWORLD_WORKSPACE+x} ]; then
  export DEVWORLD_WORKSPACE="$HOME/workspace"
else
  echo "DEVWORLD_WORKSPACE '$DEVWORLD_WORKSPACE'";
fi

if [ -z ${DEVWORLD_ROOT+x} ]; then
  export DEVWORLD_ROOT="$DEVWORLD_WORKSPACE/.devworld"
else
  echo "DEVWORLD_ROOT '$DEVWORLD_ROOT'";
fi
# Include Helpers
source $DEVWORLD_ROOT/helpers/echos.sh
source $DEVWORLD_ROOT/helpers/requirers.sh

if [ -z "$1" ]; then
      error "Project name is required. Call the script and provide the project name as an unnamed and lowercased argument."
      echo "Example: devworld myproject"
      exit -1;
else
      DEVWORLD_PROJECT_NAME="$1"
fi
shift

if [ -z ${DEVWORLD_PROJECT_WORKSPACE+x} ]; then
  export DEVWORLD_PROJECT_WORKSPACE="$DEVWORLD_WORKSPACE/$DEVWORLD_PROJECT_NAME"
  echo "DEVWORLD_PROJECT_WORKSPACE '$DEVWORLD_PROJECT_WORKSPACE'";
else
  echo "DEVWORLD_PROJECT_WORKSPACE '$DEVWORLD_PROJECT_WORKSPACE'";
fi

if [ -z ${DEVWORLD_PROJECT_WEB+x} ]; then
  export DEVWORLD_PROJECT_WEB="$DEVWORLD_PROJECT_WORKSPACE/www"
  echo "DEVWORLD_PROJECT_WEB '$DEVWORLD_PROJECT_WEB'";
else
  echo "DEVWORLD_PROJECT_WEB '$DEVWORLD_PROJECT_WEB'";
fi

bot "Project name: $DEVWORLD_PROJECT_NAME"

if [[ "$OSTYPE" == "linux-gnu" || "$OSTYPE" == "darwin"*  ]]; then
  source $DEVWORLD_ROOT/projects/devworld/devworld.sh
  Devworld__init
  if [ ! -f $DEVWORLD_ROOT/$DEVWORLD_PROJECT_NAME".installed.lock" ]; then
    ###########################
    ## Pre-install functions ##
    Devworld__preInstall
    ###########################

    "$DEVWORLD_PROJECT_NAME"__install

    # Call always at end so that all projects and patches are present
    Devilbox__install

    ###########################
    ## Post-install functions ##
    Devworld__postInstall
    ###########################
  else
    Devilbox__launch $@
  fi
else
  # Unknown.
  error "OS NOT SUPPORTED"
  exit -1;
fi

exit 0;
