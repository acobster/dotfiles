# My dotfiles.

![Travis Build status](https://api.travis-ci.org/acobster/dotfiles.svg?branch=master)

## The fast, hacky way

```
curl -fsSL https://raw.githubusercontent.com/acobster/dotfiles/master/installer.sh | sh -
```

## The slow way

### `.bash_profile`

In your `~/.bash_profile`, add the following:

```
if [ -f ~/dotfiles/.bash_profile ] ; then
  source ~/dotfiles/.bash_profile
fi
```

This allows you to have machine-specific stuff in your `.bash_profile`. If you don't need that, you can always just set up a symlink:

```
ln -s dotfiles/.bash_profile .bash_profile
```

### Other dotfiles

To initialize other stuff with sane defaults, symlink 'em up:

```
ln -s dotfiles/.vimrc .vimrc
ln -s dotfiles/.gitignore .gitignore
```

**Note that this setup assumes you have these files in the `~/dotfiles` dir. It won't work otherwise.**

## NOTES

`setup` is weird and kinda whack. It should be simpler.

Maybe just [port](https://www.youtube.com/watch?v=ck4J2Faa7Fc) everything to NixOS?

## TODO

* modularize .bash_profile
* `Unknown function: plug#begin`
* install `home-manager`

### Daily Essentials

* dotfiles
* (Neo)vim
* Git
* FZF
* tmux
* silversearcher-ag
* tree
* xclip
* net-tools
* ulauncher

### Languages / databases

* Java (JDK 11)
* Clojure
* Babashka
* Go
* Rust
* Postgres
* SQLite

### Dev tools

* Docker
* Lando
* rpi-imager
* lxd

### Misc.

* Keybase
* Typora
* VLC
* Chromium
* Brave
* rpi-imager
* lxd
* GIMP
* VirtualBox or virt-manager
* Flameshot?

### Installed, don't know what they do:

* libappindicator1
* libgconf-2-4
* libindicator7
