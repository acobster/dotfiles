#!/usr/bin/env bash

if [[ ! -f $HOME/.vimrc ]] ; then
  echo symlinking ~/.vimrc
  ln -s $HOME/dotfiles/.vimrc $HOME/.vimrc
fi

if [[ ! -d $HOME/.vim/autoload ]] ; then
  echo creating ~/.vim/autoload/
  mkdir $HOME/.vim/autoload
fi

if [[ ! -f $HOME/.vim/autoload/plug.vim ]] ; then
  curl -fLo $HOME/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

