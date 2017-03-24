# If not running interactively, don't do anything
[ -z "$PS1" ] && return


#---------
# PROMPT
#---------

if [[ -f ~/dotfiles/git-prompt.bash ]]; then
  . ~/dotfiles/git-prompt.bash
fi


#
# Web-environment-based prompt:
# put your LIVE_DIRS array definition inside a file at ~/.live.env, e.g.:
#
#   LIVE_ENV=(/var/www/example.com /var/www/example2.com)
#
__env_ps1() {
  local _live
  _live=''

  # the .live.env config file defines the LIVE_DIRS variable,
  # which tells us which directory trees to "prompt" as production
  if [ -f $HOME/.live.env ] ; then
    . $HOME/.live.env

    for d in "${LIVE_DIRS[@]}" ; do
      if [[ `pwd` =~ ^"$d".*$ ]] ; then
        # we're in a prod subtree. prompt accordingly!
        _live=' [!PRODUCTION!]'
      fi
    done
  fi

  echo "$_live"
  return 0
}

#
# include the current working dir in the prompt, abbreviating if necessary
#
__cwd_ps1() {
  local pwd_length=40
  local workingDir="${PWD/#$HOME/~}"
  if [[ $(echo -n $workingDir | wc -c | tr -d " ") -gt $pwd_length ]]
    then wd="...$(echo -n $workingDir | sed -e "s/.*\(.\{$pwd_length\}\)/\1/")"
    else wd="$(echo -n $workingDir)"
  fi

  echo $wd
}

__compose_ps1() {
  MAGENTA='\e[1;35m'
  GREEN='\e[01;32m'

  BOLD='$(tput bold 1)'
  RESET='$(tput sgr0)'

  # Git prompt
  local git_prompt
  git_prompt=''
  if [ -f ~/dotfiles/git-prompt.bash ]; then
    GIT_PS1_SHOWUNTRACKEDFILES=1
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    source ~/dotfiles/git-prompt.bash

    git_prompt="\$(__git_ps1)"
  fi

  # Easter eggs!
  dt=$(date '+%m%d')
  if [[ $dt == '0314' ]] ; then
    s='π'
  elif [[ $dt == '0628' ]] ; then
    s='τ'
  elif [[ $dt == '' ]] ; then
    s='🌎 '
  elif [[ $dt == '0316' ]] ; then
    s='⚾️ '
  elif [[ $dt == '0317' ]] ; then
    s='🍀 '
  elif [[ $dt == '1031' ]] ; then
    s='🎃 '
  elif [[ $dt -gt 1201 ]] ; then
    s='🎄 '
  elif [[ $dt == '0809' ]] ; then
    s='🍕 '
  elif [[ $dt == '0201' ]] ; then
    s='🍆 '
  elif [[ $dt == '0115' ]] ; then
    s='🥕 '
  else
    s='\$'
  fi

  export PS1="\u\[$BOLD\]\[$MAGENTA\]${git_prompt} \[$GREEN\]\$(__cwd_ps1)\$(__env_ps1)\[$RESET\] $s "
}

__compose_ps1


#---------
# PATH
#---------

if [[ -d "$HOME/bin" ]] && ! [[ $PATH =~ ":${HOME}\/bin:" ]] ; then
  export PATH=~/bin:$PATH
fi

if [[ -d "/usr/local/mysql/bin" ]] && ! [[ $PATH =~ ":mysql\/bin:" ]] ; then
  export PATH=/usr/local/mysql/bin:$PATH
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

# Alias: git cache
if [[ -z $(git config --global alias.cache) ]] ; then
  git config --global alias.cache 'diff --name-only --cached'
fi

# Alias: git rs
if [[ -z $(git config --global alias.rs) ]] ; then
  git config --global alias.rs 'reset --hard HEAD'
fi

# Alias: git cl
if [[ -z $(git config --global alias.cl) ]] ; then
  git config --global alias.cl 'clean -fd'
fi


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


