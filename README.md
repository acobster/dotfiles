# My dotfiles.

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

## TODO

* modularize .bash_profile
