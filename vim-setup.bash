#!/usr/bin/env bash

if [[ ! -f $HOME/.vim/autoload ]] ; then
  echo creating ~/.vim/autoload/
  mkdir $HOME/.vim/autoload
fi

curl -fLo $HOME/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

