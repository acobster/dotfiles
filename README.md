# My dotfiles.

## Usage

```
$ cd
$ git clone git@github.com:acobster/dotfiles
```

In your `~/.bash_profile`, add the following:

if [ -f ~/dotfiles/.bash_profile ] ; then
        source ~/dotfiles/.bash_profile
fi

This allows you to have machine-specific stuff in your `.bash_profile`. If you don't need that, you can always just set up a symlink:

```
$ ln -s dotfiles/.bash_profile .bash_profile
```

**Note that this setup assumes you have these files in the `~/dotfiles` dir. It won't work otherwise.**
