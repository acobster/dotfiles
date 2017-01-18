# If not running interactively, don't do anything
[ -z "$PS1" ] && return


#---------
# PATH
#---------

if [[ -d "$HOME/bin" ]] && ! [[ $PATH =~ ":${HOME}\/bin:" ]] ; then
  export PATH=~/bin:$PATH
fi


#---------
# Aliases
#---------

# Load common aliases
if [ -f ~/dotfiles/.aliases ] ; then
	source ~/dotfiles/.aliases
fi

# Load machine-specific aliases, too!
if [ -f ~/.aliases ] ; then
  source ~/.aliases
fi


#----------------
# Bash functions
#----------------

# Load common functions
if [ -f ~/dotfiles/.functions ] ; then
  source ~/dotfiles/.functions
fi

# Load machine-specific functions
if [ -f ~/.functions ] ; then
  source ~/.functions
fi



#---------
# Haskell
#---------

if [[ !  "$PATH" =~ "cabal" ]] && [[ -d $HOME/.cabal/bin ]] ; then
  export PATH=$HOME/.cabal/bin:$PATH
fi

if [[ !  "$PATH" =~ "Library/Haskell" ]] && [[ -d $HOME/Library/Haskell/ghc-7.8.4/lib/snap-0.14.0.6/bin ]] ; then
  export PATH=$HOME/Library/Haskell/ghc-7.8.4/lib/snap-0.14.0.6/bin:$PATH
fi



#---------
# Racket
#---------

if [[ ! $PATH =~ "Racket" ]] && [[ -d "/Applications/Racket v6.4" ]] ; then
  export PATH="/Applications/Racket v6.4/bin":$PATH
elif [[ ! $PATH =~ "Racket" ]] ; then
  for f in /Applications/Racket*; do
    [[ -e "$f" ]] && echo "Racket is not in your path but $f exists; you may want to update your path..."
    break
  done
fi



#---------
# Git
#---------

# Alias: git last
if [[ -z $(git config --global alias.last) ]] ; then
  git config --global alias.last 'diff HEAD~1 HEAD'
fi

# Alias: git last-log
if [[ -z $(git config --global alias.last-log) ]] ; then
  git config --global alias.last-log 'log -1 HEAD'
fi

# Alias: git root
if [[ -z $(git config --global alias.root) ]] ; then
  git config --global alias.root '!pwd'
fi



__env_ps1() {
  local _live
  _live=''

  if [ -f $HOME/.live.env ] ; then
    . $HOME/.live.env

    for d in "${LIVE_DIRS[@]}" ; do
      if [[ `pwd` =~ ^"$d".*$ ]] ; then
        _live=' [!PRODUCTION!]'
      fi
    done
  fi

  echo "$_live"
  return 0
}


__compose_ps1() {
  # Git prompt
  local git_prompt
  git_prompt=''
  if [ -f ~/dotfiles/git-prompt.bash ]; then
    GIT_PS1_SHOWUNTRACKEDFILES=1
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    source ~/dotfiles/git-prompt.bash

    git_prompt='\[\e[0;35m\]$(__git_ps1)\[\e[01;32m\]'
  fi

  # Web-environment-based prompt:
  # put your LIVE_DIRS array definition inside a file at ~/.live.env, e.g.:
  #
  #   LIVE_ENV=(/var/www/example.com /var/www/example2.com)
  #
  local env_ps1
  env_ps1='\[$(tput bold 1)\]\e[0:31m$(__env_ps1)\e[m\[$(tput sgr0)\]'

  echo "\h${git_prompt} \w${env_ps1} \$ "
}

export PS1=$(__compose_ps1)

# Git completion
if [ -f ~/dotfiles/git-completion.bash ]; then
	source ~/dotfiles/git-completion.bash
fi


#---------
# History
#---------

# force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend



#---------
# Window
#---------

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize



#---------
# WP CLI
#---------

if [ -f ~/dotfiles/wp-completion.bash ] ; then
	source ~/dotfiles/wp-completion.bash
fi



#------
# Ruby
#------

# set up rbenv shims
if [[ !  "$PATH" =~ ".rbenv/bin" ]] && [[ -d ~/.rbenv/bin ]] ; then
  export PATH="$HOME/.rbenv/bin:$PATH"
fi

if [[ ! "$PATH" =~ ".rbenv/shims" ]] && [[ -d $HOME/.rbenv/shims ]] ; then
  export PATH=$HOME/.rbenv/shims:$PATH
fi

# initialize rbenv
if [[ "$PATH" =~ ".rbenv/bin" ]] ; then
  eval "$(rbenv init -)"
fi

if [[ ! "$PATH" =~ ".rbenv/shims" ]] && [[ -d $HOME/.rbenv/shims ]] ; then
  export PATH="$HOME/.rbenv/shims:$PATH"
fi


