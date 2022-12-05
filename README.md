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

### Software to install automatically

* dotfiles
* (Neo)vim
* FZF
* Go
* Keybase
* Typora
* Java (JDK 11)
* Clojure
* Rust
* Docker
* Lando
* Postgres
* [Misc Linux packages](https://github.com/acobster/dotfiles/blob/main/bin/install-linux-packages)
* Balena Etcher
* VLC

### Nice to have:

* rpi-imager
* lxd
* GIMP
* Gparted
* VirtualBox or virt-manager

