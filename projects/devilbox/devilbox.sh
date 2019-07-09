#!/usr/bin/env bash

###########################
# Devworld Project Devilbox
# This script installs baselamp tool based on devilbox projet
# @see https://github.com/cytopia/devilbox

# @category Module
# @package  Beauteprivee Devworld Project
# @author   Amir Moradi https://www.linkedin.com/in/amirhmoradi
# @license  GNU GPLv3 (See LICENSE.md)
# @link     http://www.beauteprivee.com/
###########################

# Include Helpers
source $DEVWORLD_ROOT/helpers/echos.sh
source $DEVWORLD_ROOT/helpers/requirers.sh

# devilbox LAMP stack
function Devilbox__clone()
{
  if [ ! -d $DEVWORLD_ROOT/src/devilbox ]; then
    bot "Cloning Devilbox LAMP Stack from https://github.com/cytopia/devilbox"
    git clone https://github.com/cytopia/devilbox.git $DEVWORLD_ROOT/src/devilbox
    ok "Devilbox__clone finished successfully."
  else
    pushd $DEVWORLD_ROOT/src/devilbox > /dev/null 2>&1
    git fetch && git pull
    popd > /dev/null 2>&1
  fi
}

function Devilbox__modEnv()
{
  if [ ! -f $DEVWORLD_ROOT/configs/devilbox.env-example ]; then
    bot "Created devilbox's .env file from example template."
    cp -i $DEVWORLD_ROOT/src/devilbox/env-example $DEVWORLD_ROOT/configs/devilbox.env-example
  fi

  bot "Calling $DEVWORLD_PROJECT_NAME""__Devilbox__modEnv"
  $DEVWORLD_PROJECT_NAME"__Devilbox__modEnv"
}

function Devilbox__linkProjectEnvFile() {
  if [ ! -f $DEVWORLD_ROOT/$DEVWORLD_PROJECT_NAME".installed.lock" ]; then
    running "Installation in progress... Will link the env after successful install"
    Devworld__scheduleRestart
    ok
  else
    running "Linking $DEVWORLD_PROJECT_NAME .env file."
    ln -snf $DEVWORLD_ROOT/configs/"$DEVWORLD_PROJECT_NAME".devilbox.env $DEVWORLD_ROOT/src/devilbox/.env
    ok
  fi
}

function Devilbox__updateConfigurations() {
  # Reset docker-compose.override from previous projects if any.
  bot "Removing docker-compose.override from previous projects if any:"
  rm -i $DEVWORLD_ROOT/src/devilbox/docker-compose.override.yml

  bot "Removing devworld-project-custom.* from previous projects if any:"
  rm -i $DEVWORLD_ROOT/src/devilbox/cfg/*/devworld-project-custom.*

  bot "Calling $DEVWORLD_PROJECT_NAME""__Devilbox__updateConfigurations"
  $DEVWORLD_PROJECT_NAME"__Devilbox__updateConfigurations"
}

function Devilbox__startDocker()
{
  bot "I need DOCKER to be running..."
  if [[ "$OSTYPE" == "darwin"* ]]; then

    running "Launching DOCKER, please confirm different dialogs if any and make sure the DOCKER engine is running."
    /Applications/Docker.app/Contents/MacOS/Docker &
    ok
  else
    running "Please launch DOCKER and make sure the engine is running."
  fi

  running "Waiting 60s for docker to be up & running"
  sleep 60
  ok
}

## DEPRECATED
function Devilbox__generateSSLKeys()
{
  # DEPRECATED
  error "Deprecated function... Not doing anything."
}

function Devilbox__installCA__Linux()
{
  if [ ! -f $DEVWORLD_ROOT/devilbox-ca.installed.lock ]; then
    if [[ -e $DEVWORLD_ROOT/src/devilbox/ca/devilbox-ca.crt ]]; then
      sudo cp -i $DEVWORLD_ROOT/src/devilbox/ca/devilbox-ca.crt /usr/local/share/ca-certificates/devilbox-ca.crt \
       && sudo update-ca-certificates && touch $DEVWORLD_ROOT/devilbox-ca.installed.lock
    else
      error "Missing devilbox CA for SSL. See devilbox documentation : https://devilbox.readthedocs.io/en/latest/intermediate/setup-valid-https.html "
      #exit -1;
    fi
  fi
}

function Devilbox__installCA__OSX()
{
  if [ ! -f $DEVWORLD_ROOT/devilbox-ca.installed.lock ]; then
    if [[ -e $DEVWORLD_ROOT/src/devilbox/ca/devilbox-ca.crt ]]; then
      running "Adding Devilbox's CA to trusted CAs in the OS."
      sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain $DEVWORLD_ROOT/src/devilbox/ca/devilbox-ca.crt && touch $DEVWORLD_ROOT/devilbox-ca.installed.lock
      ok
    else
      if [ ! -f $DEVWORLD_ROOT/$DEVWORLD_PROJECT_NAME".installed.lock" ]; then
          running "Installation in progress... Will add the CA after first successful launch of Devilbox"
          echo " "
          echo "  See devilbox documentation : https://devilbox.readthedocs.io/en/latest/intermediate/setup-valid-https.html "
      else
        if [ ! -f $DEVWORLD_ROOT/src/devilbox/ca/devilbox-ca.crt ]; then
            running "First launch of Devilbox... Will generate the CA and restart your Devworld automatically. See devilbox documentation : https://devilbox.readthedocs.io/en/latest/intermediate/setup-valid-https.html "
            Devworld__scheduleRestart
            ok
        else
          error "Missing devilbox CA for SSL. See devilbox documentation : https://devilbox.readthedocs.io/en/latest/intermediate/setup-valid-https.html "
        fi
      fi
      #exit -1;
    fi
  fi
}

function Devilbox__installCA()
{
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    Devilbox__installCA__Linux
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    Devilbox__installCA__OSX
  else
    # Unknown.
    echo "unknown OS NOT SUPPORTED"
    exit -1;
  fi
}

function Devilbox__install()
{
  Devilbox__clone
  Devilbox__modEnv
  Devilbox__updateConfigurations
  Devilbox__startDocker
  #Devilbox__generateSSLKeys
}

function Devilbox__launch()
{
  Devilbox__updateConfigurations
  if [[ "$DEVWORLD_SCHEDULERESTART" == "1" ]]; then
    cd $DEVWORLD_ROOT/src/devilbox/ && docker-compose up -d bind mysql memcd elasticsearch $@
    if [ -z `docker ps -q --no-trunc | grep $(docker-compose ps -q httpd)` ]; then
      error "Devilbox container httpd is not running"
    else
      docker-compose stop
      Devilbox__installCA
      cd $DEVWORLD_ROOT/src/devilbox/ && docker-compose up bind mysql memcd elasticsearch $@
    fi
  else
    cd $DEVWORLD_ROOT/src/devilbox/ && docker-compose up bind mysql memcd elasticsearch $@
  fi
}
