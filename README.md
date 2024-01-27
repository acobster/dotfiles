# My dotfiles.

## TODO

* audit vim config
    * color
    * syntastic
    * racket
* port vim config to Lua
* Lando?
* GNOME Dock
* Fix Keybase
* Setup environmnets:
    * Generic server
    * Plex
    * Concierge
* Fix rainbow + solarized light theme

## INCLUDED SOFTWARE

### ✅ Daily Essentials

* dotfiles
* neovim
* git
* fzf
* tmux
* silversearcher-ag
* tree
* xclip
* net-tools
* ulauncher

### λ Languages

* Java (OpenJDK 21)
* Clojure
* Babashka
* Lua

### 🤷 Misc.

* rpi-imager
* Keybase (not working)
* VLC
* Ungoogled Chromium
* Brave
* GIMP
* Zoom
* Discord
* Zulip

**NOTE: for desktop apps on Ubuntu, you need to explicitly source `~/.profile` from a script inside `/etc/profile.d/`:**

```sh
# /etc/profile.d/nix.sh

if [ -f /home/tamayo/.profile ] ; then
  . /home/tamayo/.profile
fi
```
