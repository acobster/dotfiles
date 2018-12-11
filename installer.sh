#!/usr/bin/env bash

if ! [[ -d ~/dotfiles ]]
then
  git clone git@github.com:acobster/dotfiles.git ~/dotfiles

  status="$?"
  if [[ $status != '0' ]]
  then
    echo "git clone git@github.com:acobster/dotfiles.git ~/dotfiles failed with status $status"
    exit $status
  fi
fi

~/dotfiles/setup

