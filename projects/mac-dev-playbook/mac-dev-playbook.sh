#!/usr/bin/env bash

###########################
# Devworld Project mac-dev-playbook
# This script installs Mac Development Ansible Playbook projet
# @see https://github.com/geerlingguy/mac-dev-playbook

# @category Module
# @package  Beauteprivee Mac-Dev-Playbook Project
# @author   Amir Moradi https://www.linkedin.com/in/amirhmoradi
# @license  GNU GPLv3 (See LICENSE.md)
# @link     http://www.beauteprivee.com/
###########################

# Include Helpers
source $DEVWORLD_ROOT/helpers/echos.sh
source $DEVWORLD_ROOT/helpers/requirers.sh

function MDAP__clone()
{
  running "Cloning/Updating Mac Development Ansible Playbook from https://github.com/geerlingguy/mac-dev-playbook "
  if [ ! -d $DEVWORLD_ROOT/src/mac-dev-playbook ]; then
    git clone https://github.com/geerlingguy/mac-dev-playbook.git $DEVWORLD_ROOT/src/mac-dev-playbook
  else
    pushd $DEVWORLD_ROOT/src/mac-dev-playbook > /dev/null 2>&1
    git fetch && git pull
    popd > /dev/null 2>&1
  fi
  ok "MDAP__clone finished successfully."
}

function MDAP__modConfig()
{
  cp -i $DEVWORLD_ROOT/projects/mac-dev-playbook/mods/config.yml $DEVWORLD_ROOT/configs/mac-dev-playbook.config.yml
  ln -snf $DEVWORLD_ROOT/configs/mac-dev-playbook.config.yml $DEVWORLD_ROOT/src/mac-dev-playbook/config.yml
}

function MDAP__install()
{
  pushd $DEVWORLD_ROOT/src/mac-dev-playbook > /dev/null 2>&1

  ansible-galaxy install -r requirements.yml
  ansible-playbook main.yml -i inventory -K

  popd > /dev/null 2>&1
}
