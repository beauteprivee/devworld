#!/usr/bin/env bash

###########################
# Devworld Project dotfiles
# This script installs the dotfiles project
# @see https://github.com/atomantic/dotfiles

# @category Module
# @package  Beauteprivee Dotfiles Project
# @author   Amir Moradi https://www.linkedin.com/in/amirhmoradi
# @license  GNU GPLv3 (See LICENSE.md)
# @link     http://www.beauteprivee.com/
###########################

# Include Helpers
source $DEVWORLD_ROOT/helpers/echos.sh
source $DEVWORLD_ROOT/helpers/requirers.sh

function Dotfiles__clone()
{
  running "Running Dotfiles__clone"
  if [ ! -d $DEVWORLD_ROOT/src/dotfiles ]; then
    bot "Cloning dotfiles project from https://github.com/atomantic/dotfiles"
    git clone --recurse-submodules https://github.com/atomantic/dotfiles $DEVWORLD_ROOT/src/dotfiles
  else
    pushd $DEVWORLD_ROOT/src/dotfiles > /dev/null 2>&1
    git fetch && git pull
    popd > /dev/null 2>&1
    if [ ! -f $DEVWORLD_ROOT/src/dotfiles/config.js ]; then
      cp -i $DEVWORLD_ROOT/src/dotfiles/config.js.original-backup $DEVWORLD_ROOT/src/dotfiles/config.js
    fi
  fi
  ok
}

function Dotfiles__install()
{
  Dotfiles__clone
  Dotfiles__modConfig

  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    bot "Please make sure you have the following tools/libraries available:"

    bot "nvm"
    bot "npm <= latest stable, managed by nvm"
    bot "git"
    bot "git-flow"

    read -r -p "Are all requirements above satisfied? [y|N] " response
    if [[ $response =~ (no|n|N) ]];then
      exit -1;
    else
        ok "Going forward...";
    fi
  else
    pushd $DEVWORLD_ROOT/src/dotfiles > /dev/null 2>&1
    bash ./install.sh
    popd > /dev/null 2>&1

    now=$(date +"%Y.%m.%d.%H.%M.%S")
    mv $HOME/.dotfiles $HOME/.dotfiles_backup/$now/
    cp -iR $DEVWORLD_ROOT/src/dotfiles/ $HOME/.dotfiles/
  fi

}

function Dotfiles__modConfig()
{
  if [ ! -f $DEVWORLD_ROOT/src/dotfiles/config.js.original-backup ]; then
    cp -i $DEVWORLD_ROOT/src/dotfiles/config.js $DEVWORLD_ROOT/src/dotfiles/config.js.original-backup
  fi
  rm -f $DEVWORLD_ROOT/src/dotfiles/config.js

  # Project specific dotfiles.config.js override?
  if [ -f $DEVWORLD_ROOT/projects/$DEVWORLD_PROJECT_NAME/mods/dotfiles/config.js ]; then
    cp -i $DEVWORLD_ROOT/projects/$DEVWORLD_PROJECT_NAME/mods/dotfiles/config.js $DEVWORLD_ROOT/configs/$DEVWORLD_PROJECT_NAME.dotfiles.config.js
    ln -snf $DEVWORLD_ROOT/configs/$DEVWORLD_PROJECT_NAME.dotfiles.config.js $DEVWORLD_ROOT/src/dotfiles/config.js
  else
    cp -i $DEVWORLD_ROOT/projects/dotfiles/mods/config.js $DEVWORLD_ROOT/configs/dotfiles.config.js
    ln -snf $DEVWORLD_ROOT/configs/dotfiles.config.js $DEVWORLD_ROOT/src/dotfiles/config.js
  fi
}

function Dotfiles__postInstall()
{
  running "Running Dotfiles__postInstall for more features..."
  # Install oh-my-zsh custom theme:
  if [[ ! -d "$HOME/.dotfiles/oh-my-zsh/custom/themes/doubleend.zsh-theme" ]]; then
    bot "Installing DoubleEnd zsh theme."
    mkdir -p $HOME/.dotfiles/oh-my-zsh/custom/themes/
    ln -snf $DEVWORLD_ROOT/projects/oh-my-zsh/mods/themes/doubleend.zsh-theme $HOME/.dotfiles/oh-my-zsh/custom/themes/doubleend.zsh-theme
    sed -i '' 's/export ZSH_THEME="powerlevel9k\/powerlevel9k"/export ZSH_THEME="doubleend"/' $HOME/.zshrc;
    ok
  fi

  running "Adding Bitbucket config to .gitconfig file."
  if [[ -z ${DEVWORLD_BITBUCKET_USERNAME+x} ]]; then
    read -r -p "What is your BITBUCKET username (NOT EMAIL)? " DEVWORLD_BITBUCKET_USERNAME
  else
    echo "[bitbucket]" >> $HOME/.gitconfig
    echo "  user = $DEVWORLD_BITBUCKET_USERNAME" >> $HOME/.gitconfig
  fi
  ok

  running "Modifying zsh plugins for bash completion."
  sed -i "s/plugins/plugins/" $HOME/.zshrc > /dev/null 2>&1 | true
  if [[ ${PIPESTATUS[0]} != 0 ]]; then
    #echo
    #running "looks like you are using MacOS sed rather than gnu-sed, accommodating"
    sed -i '' "s/plugins=(/plugins=(git-flow httpie composer docker docker-compose npm /" $HOME/.zshrc
    ok
  else
    #echo
    #bot "looks like you are already using gnu-sed. woot!"
    sed -i 's/plugins=(/plugins=(git-flow httpie composer docker docker-compose npm /' $HOME/.zshrc
    ok
  fi

}
