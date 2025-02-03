if [[ -f ~/.profile ]] ; then
  source ~/.profile
fi
source ~/.bash_profile

# If we are not on NixOS, we need to source the Nix environment itself.
if [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]] ; then
  source ~/.nix-profile/etc/profile.d/nix.sh
fi
