# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# NOTE: these need to use the hard-coded /home/tamayo directory for the XDG
# profile to work correctly.

# Load the Nix profile
if [[ -e /home/tamayo/.nix-profile/etc/profile.d/nix.sh ]] ; then
  source /home/tamayo/.nix-profile/etc/profile.d/nix.sh;
fi
# Tell the system where to look for desktop apps
if [[ -d /home/tamayo/.nix-profile/share ]] ; then
    export XDG_DATA_DIRS="/home/tamayo/.nix-profile/share:$XDG_DATA_DIRS"
fi
if [[ -d /home/tamayo/.nix-profile/share/applications ]] ; then
    export XDG_DATA_DIRS="/home/tamayo/.nix-profile/share/applications:$XDG_DATA_DIRS"
fi

# Desktop apps need extra PATH info in the NON-INTERACTIVE shell
# to find executables.
if [[ -d /home/tamayo/.nix-profile/bin ]] ; then
  export PATH="/home/tamayo/.nix-profile/bin:$PATH"
fi
