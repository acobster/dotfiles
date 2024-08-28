#!/usr/bin/env bash

read -p 'ARE YOU SURE?!? (y/N) ' confirm
if [[ "$confirm" != y ]] ; then
  exit 1
fi

sudo systemctl stop nix-daemon.service
sudo systemctl disable nix-daemon.socket nix-daemon.service
sudo systemctl daemon-reload
sudo rm -rf /etc/nix /etc/profile.d/nix.sh /etc/tmpfiles.d/nix-daemon.conf /nix ~root/.nix-channels ~root/.nix-defexpr ~root/.nix-profile

for i in $(seq 1 32); do
  sudo userdel nixbld$i
done
sudo groupdel nixbld

rm -rf ~/.bash_profile ~/.bashrc ~/.githelpers ~/.gtkrc-2.0 ~/.nix-profile ~/.profile ~/.tmux.conf ~/.nix-channels ~/.nix-defexpr ~/.config/nix

if [[ -f /etc/profile.d/nix.sh ]] ; then
  read -p "Remove /etc/profile.d/nix.sh? (y/N) " remove_etc_profile
  if [[ "$remove_etc_profile" != y ]] ; then
    sudo rm /etc/profile.d/nix.sh
  fi
fi

if [[ -f "$HOME/.profile.backup" ]] ; then
  read -p "Restore $HOME/.profile.backup? (y/N) " restore_profile
  if [[ "$restore_profile" != y ]] ; then
    mv "$HOME/.profile.backup" "$HOME/.profile"
  fi
fi

read -p 'remove ~/dotfiles? (y/N) ' remove_dotfiles
if [[ "$remove_dotfiles" != y ]] ; then
  rm -rf ~/dotfiles
fi

echo Done.
