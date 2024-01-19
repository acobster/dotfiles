# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# Load the Nix profile
if [[ -e /home/tamayo/.nix-profile/etc/profile.d/nix.sh ]] ; then
  source /home/tamayo/.nix-profile/etc/profile.d/nix.sh;
fi
# Tell the system where to look for desktop apps
if [[ -d "$HOME/.nix-profile/share" ]] ; then
    export XDG_DATA_DIRS=$HOME/.nix-profile/share:$XDG_DATA_DIRS
fi
if [[ -d "$HOME/.nix-profile/share/applications" ]] ; then
    export XDG_DATA_DIRS=$HOME/.nix-profile/share/applications:$XDG_DATA_DIRS
fi

# Desktop apps need extra PATH info in the NON-INTERACTIVE shell
# to find executables.
if [[ -d "$HOME/.nix-profile/bin" ]] ; then
  export PATH="$HOME/.nix-profile/bin:$PATH"
fi
