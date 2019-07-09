# Beauteprivee Devworld

Devworld provides you with a modular, standard and automated development environment for your projects and teams.
It provides a modular design, so that you can setup your projects to run in the devworld environment.

Devworld uses Docker to run.

It provides optional updates to your macOS (linux will be coming soon) machine with better system defaults, preferences, software configuration and even auto-install some handy development tools and apps that our developer friends find helpful.

You don't need to install or configure anything upfront! This works with a brand-new machine from the factory as well as an existing machine that you've been working with for years.

# Acknowledgments
Devworld uses multiple open-source projects to work.

Many thanks for the great works from:

[Devilbox Project](https://github.com/cytopia/devilbox)
[Atomantic Dotfiles Project](https://github.com/atomantic/dotfiles)
[geerlingguy Mac Development Ansible Playbook Project](https://github.com/geerlingguy/mac-dev-playbook)
[Oh My Zsh Project](https://github.com/robbyrussell/oh-my-zsh)
[Docker](https://github.com/docker)


# Installation

> REVIEW WHAT THIS SCRIPT DOES PRIOR TO RUNNING
> It's always a good idea to review arbitrary code before running it on your machine with sudo power!

> ***You are responsible*** for everything this script does to your machine [see LICENSE.md](./LICENSE.md)

## You need a devworld project for managing your code/applications. (Example project will be available soon).

In the following code:
* Type-in your devworld sub project's name
* Type-in your devworld sub project's git repo username
* Type-in your devworld sub project's git repo url (Without the scheme (https:// , ssh:// , git://) part)
* Optionally modify the variables (if you know what you do)
* Run the code:

```bash

export DEVWORLD_PROJECT_NAME="demo-wordpress"
export DEVWORLD_PROJECT_GIT_USERNAME="mysupergitusername"
export DEVWORLD_PROJECT_GIT_URL="bitbucket.org:beauteprivee/devworld-project-demo-wordpress.git"

export DEVWORLD_PROJECT_GIT_REPO="$DEVWORLD_PROJECT_GIT_USERNAME@$DEVWORLD_PROJECT_NAME.$DEVWORLD_PROJECT_GIT_URL"
export DEVWORLD_WORKSPACE="$HOME/workspace"
export DEVWORLD_ROOT="$DEVWORLD_WORKSPACE/.devworld"

mkdir -p $DEVWORLD_WORKSPACE
git clone git@github.com:beauteprivee/devworld.git $DEVWORLD_ROOT
cd $DEVWORLD_ROOT && bash ./world.sh $DEVWORLD_PROJECT_NAME

```

> Note: running world.sh is idempotent. You can run it again and again as you add new features or software to the scripts! We'll regularly add new configurations so keep an eye on this repo as it grows and optimizes.

## Restoring Dotfiles

If you have existing dotfiles for configuring git, zsh, vim, etc, these will be backed-up into `~/.dotfiles_backup/$(date +"%Y.%m.%d.%H.%M.%S")` and replaced with the files from this project. You can restore your original dotfiles by using `./restore.sh $RESTOREDATE` where `$RESTOREDATE` is the date folder name you want to restore.

> The restore script does not currently restore system settings--only your original dotfiles. To restore system settings, you'll need to manually undo what you don't like (so don't forget to fork, review, tweak)


# License
This project is licensed under GNU GPLv3. Please refer to [LICENSE.md](./LICENSE.md)

Devworld provides you with a standard and automated development environment.
Copyright (C) 2019 Beaute Privee SAS France - Amir Moradi https://www.linkedin.com/in/amirhmoradi

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

Please fork, contribute and share.

# Contributions
Contributions are always welcome in the form of pull requests with explanatory comments.

Please refer to the [Contributor Covenant](./CONTRIBUTING.md)
