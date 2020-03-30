#!/usr/bin/env bash

###########################
# Devworld Project devworld core
# This script installs the devworld core

# @category Module
# @package  Beauteprivee Devworld Project
# @author   Amir Moradi https://www.linkedin.com/in/amirhmoradi
# @license  GNU GPLv3 (See LICENSE.md)
# @link     http://www.beauteprivee.com/
###########################

# Include Helpers
source $DEVWORLD_ROOT/helpers/echos.sh
source $DEVWORLD_ROOT/helpers/requirers.sh


function Devworld__preInstall()
{
  mkdir -p $DEVWORLD_ROOT/configs

  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    Devworld__preInstall__Linux
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    Devworld__preInstall__OSX
    Dotfiles__install
  else
    # Unknown.
    echo "unknown OS NOT SUPPORTED"
    exit -1;
  fi
}
function Devworld__preInstall__Linux()
{
  echo "TODO"
}

function Devworld__preInstall__OSX()
{
  if [ ! -f $DEVWORLD_ROOT/"devworld-pre.installed.lock" ]; then
    # ###########################################################
    # Install non-brew various tools (PRE-BREW Installs)
    # ###########################################################
    bot "Ensuring build/install tools are available"
    xcode-select --install 2>&1 > /dev/null
    sudo xcode-select -s /Applications/Xcode.app/Contents/Developer 2>&1 > /dev/null
    sudo xcodebuild -license accept 2>&1 > /dev/null
    ok

    # ###########################################################
    # install homebrew (CLI Packages)
    # ###########################################################
    running "Checking Homebrew"
    brew_bin=$(which brew) 2>&1 > /dev/null
    if [[ $? != 0 ]]; then
      action "Installing Homebrew"
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      if [[ $? != 0 ]]; then
        error "Unable to install Homebrew, script $0 abort!"
        exit 2
      fi
    else
      ok
      bot "Homebrew"
      read -r -p "Run brew update && upgrade? [y|N] " response
      if [[ $response =~ (y|yes|Y) ]]; then
        action "updating homebrew..."
        brew update
        ok "homebrew updated"
        action "upgrading brew packages..."
        brew upgrade
        ok "brews upgraded"
      else
        ok "skipped brew package upgrades."
      fi
    fi

    # ###########################################################
    # install brew cask (UI Packages)
    # ###########################################################
    running "Checking brew-cask install"
    output=$(brew tap | grep cask)
    if [[ $? != 0 ]]; then
      action "installing brew-cask"
      require_brew caskroom/cask/brew-cask
    fi
    brew tap caskroom/versions > /dev/null 2>&1
    ok

    ## Fix missing fonts
    brew untap caskroom/fonts
    brew tap homebrew/cask-fonts

    #./fonts/install.sh
    #brew tap caskroom/fonts
    require_cask font-fontawesome
    require_cask font-awesome-terminal-fonts
    require_cask font-hack
    require_cask font-inconsolata-dz-for-powerline
    require_cask font-inconsolata-g-for-powerline
    require_cask font-inconsolata-for-powerline
    require_cask font-roboto-mono
    require_cask font-roboto-mono-for-powerline
    require_cask font-source-code-pro

    # ###########################################################
    # Allow installation from all sources
    # ###########################################################
    running "Allow installation from all sources"
    sudo spctl --master-disable

    touch $DEVWORLD_ROOT/"devworld-pre.installed.lock"
  else
    bot "Devworld initial requirements already installed."
  fi

  ok
}

function Devworld__init()
{
  source $DEVWORLD_ROOT/projects/dotfiles/dotfiles.sh
  # Project shall always be init before devilbox
  Devworld__initProject
  Devworld__generateProjectSshKeys
  Devworld__initDevilbox
}

function Devworld__initProject()
{
  running "Fetching/Updating Devworld $DEVWORLD_PROJECT_NAME project"
  if [ ! -d $DEVWORLD_ROOT/projects/$DEVWORLD_PROJECT_NAME/ ]; then
    if [ -z ${DEVWORLD_PROJECT_GIT_REPO+x} ]; then
      echo " "
      error "DEVWORLD_PROJECT_GIT_REPO variable is required. You may set it in env vars before running the script. See README.md for more info."
      exit -1;
    else
      echo "DEVWORLD_PROJECT_GIT_REPO '$DEVWORLD_PROJECT_GIT_REPO'";
    fi
    git clone $DEVWORLD_PROJECT_GIT_REPO $DEVWORLD_ROOT/projects/$DEVWORLD_PROJECT_NAME
  else
    pushd $DEVWORLD_ROOT/projects/$DEVWORLD_PROJECT_NAME > /dev/null 2>&1

    if [ -d .git ]; then
      git fetch && git pull
    else
      bot "Project is not linked to a GIT repo. Skipping pull."
    fi
    popd > /dev/null 2>&1
  fi

  if [ ! -f $DEVWORLD_ROOT/projects/$DEVWORLD_PROJECT_NAME/$DEVWORLD_PROJECT_NAME".sh" ]; then
    error "Error fetching and including project script."
    exit -1;
  else
    source $DEVWORLD_ROOT/projects/$DEVWORLD_PROJECT_NAME/$DEVWORLD_PROJECT_NAME".sh"
  fi
  if [ ! -d $DEVWORLD_PROJECT_WEB ]; then
    mkdir -p $DEVWORLD_PROJECT_WEB
  fi

  ok
}

function Devworld__initDevilbox()
{
  running "Init Devilbox"
  source $DEVWORLD_ROOT/projects/devilbox/devilbox.sh
  Devilbox__installCA
  Devilbox__linkProjectEnvFile
  ok
}


function Devworld__postInstall()
{
  running "Devworld Post Install (updates, patches, cleanup)"
  echo " "
  Dotfiles__postInstall
  brew untap caskroom/fonts
  brew tap homebrew/cask-fonts

  brew untap caskroom/versions
  brew tap homebrew/cask-versions

  brew update && brew upgrade
  brew cask upgrade
  brew cleanup

  echo "export DEVWORLD_WORKSPACE="${DEVWORLD_WORKSPACE} >> $HOME/.profile
  echo "export DEVWORLD_ROOT="${DEVWORLD_ROOT} >> $HOME/.profile
  echo "export DEVWORLD_PROJECT_GIT_USERNAME="${DEVWORLD_PROJECT_GIT_USERNAME} >> $HOME/.profile
  echo "export DEVWORLD_BITBUCKET_USERNAME="${DEVWORLD_BITBUCKET_USERNAME} >> $HOME/.profile
  touch $DEVWORLD_ROOT/$DEVWORLD_PROJECT_NAME".installed.lock"

  #bot "Start the LAMP stack by running world.sh or 'cd $DEVWORLD_ROOT/src/devilbox && docker-compose up ...' see https://github.com/cytopia/devilbox for more info."
  running "Finished Install"
  warn "Close this terminal and relauch a new one. Then:"
  bot "Run the following command from anywhere to start the devworld:"
  bot "devworld"
  echo " "
  bot "(i) you can also run the unaliased command:"
  echo "cd $DEVWORLD_ROOT/src/devilbox/ && docker-compose up bind mysql memcd elasticsearch"
  echo " "

  echo "alias devworld='bash $DEVWORLD_ROOT/world.sh \$@'" >> $HOME/.shellaliases

  ok
}

function Devworld__scheduleRestart()
{
  echo " "
  bot "(i) Devworld is scheduled to restart automatically."
  DEVWORLD_SCHEDULERESTART=1
}

function Devworld__generateProjectSshKeys()
{
  running "Checking $DEVWORLD_PROJECT_NAME project SSH keys"
  if [ ! -f $HOME/.ssh/$DEVWORLD_PROJECT_NAME".id_rsa.pub" ]; then
    read -r -p "Shall I check for your ssh keys availability for your $DEVWORLD_PROJECT_NAME account? [y|N] " response
    if [[ $response =~ (yes|y|Y) ]];then
      ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/$DEVWORLD_PROJECT_NAME".id_rsa" -q -N "" -C "$USERNAME@$DEVWORLD_PROJECT_NAME"
      ssh-add $HOME/.ssh/$DEVWORLD_PROJECT_NAME.id_rsa
    else
        ok "Skipped key generation. You shall manage your ssh keys.";
    fi
  else
    ok "Found correct ssh keys."
  fi
}
