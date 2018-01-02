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
  local home_pattern=$(echo $HOME | sed 's/\//\\\//g')
  local workingDir=$(echo $PWD | sed "s/$home_pattern/~/")
  if [[ $(echo -n $workingDir | wc -c | tr -d " ") -gt $pwd_length ]]
    then wd="...$(echo -n $workingDir | sed -e "s/.*\(.\{$pwd_length\}\)/\1/")"
    else wd="$(echo -n $workingDir)"
  fi

  echo $wd
  return 0
}


__user_host_ps1() {

  # abbreviate username/hostname combos on normal machines
  user_host="$(whoami)@$(hostname)"

  user_host="$(echo $user_host | sed 's/ctamayo@ctamayo-sitecrafting/⚙/')"
  user_host="$(echo $user_host | sed 's/acobster@Tomato.domain/🍅/')"
  user_host="$(echo $user_host | sed 's/acobster@CobyTamsMacBook.domain/🍅/')"

  echo "$user_host"
  return 0
}


__ps1_symbol() {
  # Easter eggs!
  # strip leading zero from mmdd date
  dt=$(date '+%m%d' | sed 's/^0//')

  # same for time
  t=$(date '+%H' | sed 's/^0//')

  if [[ $(hostname) == 'ctamayo-sitecrafting' ]] && [[ $t -gt 16 ]] ; then
    # LOG YOUR TIME
    s='🕓 '
  elif [[ $dt == '314' ]] ; then
    s='π'
  elif [[ $dt == '628' ]] ; then
    s='τ'
  elif [[ $dt == '422' ]] ; then
    s='🌎 '
  elif [[ $dt == '316' ]] ; then
    s='⚾️ '
  elif [[ $dt == '317' ]] ; then
    s='🍀 '
  elif [[ $dt == '1031' ]] ; then
    s='🎃 '
  elif [[ $dt == '1231' ]] || [[ $dt == '101' ]] ; then
    s='🎉 '
  elif [[ $dt -gt 1201 ]] ; then
    s='🎄 '
  elif [[ $dt == '809' ]] ; then
    s='🍕 '
  elif [[ $dt == '201' ]] ; then
    s='🍆 '
  elif [[ $dt == '115' ]] ; then
    s='🥕 '
  else
    s='\$'
  fi

  echo "$s"
  return 0
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

    # abbreviate git branch names!
    git_prompt="\$(echo $git_prompt | sed 's/feature\\//✔ /')"
    git_prompt="\$(echo $git_prompt | sed 's/experiment\\//🔬 /')"
    git_prompt="\$(echo $git_prompt | sed 's/bugfix\\//🐛 /')"
    git_prompt="\$(echo $git_prompt | sed 's/test\\//❓ /')"
  fi

  export PS1="\$(__user_host_ps1) \[$BOLD\]\[$MAGENTA\]${git_prompt} \[$GREEN\]\$(__cwd_ps1)\$(__env_ps1)\[$RESET\] $(__ps1_symbol) "
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

if [[ ! $PATH =~ "dotfiles/bin:" ]] ; then
  export PATH=$HOME/dotfiles/bin:$PATH
fi



#----------
# Binaries
#----------

if [[ -f /System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc ]] && ! [[ -f $HOME/dotfiles/bin/jsc ]] ; then
  ln -s /System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc $HOME/dotfiles/bin/jsc
fi



#----------
# SSH Keys
#----------

if [[ -z $ADDED_DEFAULT_KEYS && -f ~/.ssh/default-keys ]] ; then
  cat ~/.ssh/default-keys | while read k ; do
    if [[ -z $(ssh-add -l | grep $k) ]] ; then
      ssh-add $k
    fi
  done
  export ADDED_DEFAULT_KEYS=1
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


#--------
# Colors
#--------

if [[ -f ~/.dir_colors/dircolors ]] ; then
  eval `dircolors ~/.dir_colors/dircolors`
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
if [[ ! $PATH =~ "Racket" ]] && [[ -d "/Applications/Racket v6.8" ]] ; then
  export PATH="/Applications/Racket v6.8/bin":$PATH
elif [[ ! $PATH =~ "Racket" ]] && [[ -d "/Applications/Racket v6.4" ]] ; then
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

# Global .gitignore
if [[ -z $(git config --global core.excludesfile) ]] ; then
  git config --global core.excludesfile '~/.gitignore'
fi

# Alias: git st
if [[ -z $(git config --global alias.st) ]] ; then
  git config --global alias.st 'status'
fi

# Alias: git sh
if [[ -z $(git config --global alias.sh) ]] ; then
  git config --global alias.sh 'stash'
fi

# Alias: git aa
if [[ -z $(git config --global alias.aa) ]] ; then
  git config --global alias.aa 'add --all'
fi

# Alias: git d
if [[ -z $(git config --global alias.d) ]] ; then
  git config --global alias.d 'diff'
fi

# Alias: git dc
if [[ -z $(git config --global alias.dc) ]] ; then
  git config --global alias.dc 'diff --cached'
fi

# Alias: git dw
if [[ -z $(git config --global alias.dw) ]] ; then
  git config --global alias.dw 'diff -w'
fi

# Alias: git files
if [[ -z $(git config --global alias.files) ]] ; then
  git config --global alias.files 'diff --name-only'
fi

# Alias: git ha - add hunks interactively
if [[ -z $(git config --global alias.ha) ]] ; then
  git config --global alias.ha 'add --all -p'
fi

# Alias: git co
if [[ -z $(git config --global alias.co) ]] ; then
  git config --global alias.co 'checkout'
fi

# Alias: git ci
if [[ -z $(git config --global alias.ci) ]] ; then
  git config --global alias.ci 'commit'
fi

# Alias: git cam
if [[ -z $(git config --global alias.cam) ]] ; then
  git config --global alias.cam 'commit -am'
fi

# Alias: git files
if [[ -z $(git config --global alias.files) ]] ; then
  git config --global alias.files 'diff --name-only'
fi

# Alias: git root
if [[ -z $(git config --global alias.root) ]] ; then
  git config --global alias.root 'rev-parse --show-toplevel'
fi

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
  git config --global alias.rs 'reset'
fi

# Alias: git cl
if [[ -z $(git config --global alias.cl) ]] ; then
  git config --global alias.cl 'clean -fd'
fi

# Alias: git b
if [[ -z $(git config --global alias.b) ]] ; then
  git config --global alias.b 'branch'
fi

# Alias: git ff
if [[ -z $(git config --global alias.ff) ]] ; then
  git config --global alias.ff 'merge --ff-only'
fi

# Alias: git where
# which branches is this hash on?
if [[ -z $(git config --global alias.where) ]]; then
  git config --global alias.where 'branch --contains'
fi

# Fancy logging.
# Stolen from https://github.com/garybernhardt/dotfiles/blob/master/.gitconfig
#   h = head
#   hp = head with patch
#   r = recent commits, only current branch
#   ra = recent commits, all reachable refs
#   l = all commits, only current branch
#   la = all commits, all reachable refs

if [[ -z $(git config --global alias.head) ]] ; then
  git config --global alias.head '!git r -1'
fi
if [[ -z $(git config --global alias.h) ]] ; then
  git config --global alias.h '!git head'
fi
if [[ -z $(git config --global alias.hp) ]] ; then
  git config --global alias.hp '!. ~/.githelpers && show_git_head'
fi
if [[ -z $(git config --global alias.r) ]] ; then
  git config --global alias.r '!GIT_NO_PAGER=1 git l -30'
fi
if [[ -z $(git config --global alias.ra) ]] ; then
  git config --global alias.ra '!git r --all'
fi
if [[ -z $(git config --global alias.l) ]] ; then
  git config --global alias.l '!. ~/.githelpers && pretty_git_log'
fi
if [[ -z $(git config --global alias.la) ]] ; then
  git config --global alias.la '!git l --all'
fi

# Alias: git l1
if [[ -z $(git config --global alias.l1) ]] ; then
  git config --global alias.l1 '!. ~/.githelpers && pretty_git_log -1'
fi

# Alias: git l2
if [[ -z $(git config --global alias.l2) ]] ; then
  git config --global alias.l2 '!. ~/.githelpers && pretty_git_log -2'
fi

# Alias: git l3
if [[ -z $(git config --global alias.l3) ]] ; then
  git config --global alias.l3 '!. ~/.githelpers && pretty_git_log -3'
fi

# Alias: git l4
if [[ -z $(git config --global alias.l4) ]] ; then
  git config --global alias.l4 '!. ~/.githelpers && pretty_git_log -4'
fi

# Alias: git l5
if [[ -z $(git config --global alias.l5) ]] ; then
  git config --global alias.l5 '!. ~/.githelpers && pretty_git_log -5'
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

# initialize rbenv
if [[ ! "$PATH" =~ ".rbenv/shims" ]] && [[ -d $HOME/.rbenv/shims ]] ; then
  export PATH="$HOME/.rbenv/shims:$PATH"
fi


#--------
# Golang
#--------

if [[ ! "$PATH" =~ "/usr/local/go/bin:" ]] && [[ -d /usr/local/go ]] ; then
  export PATH="/usr/local/go/bin:$PATH"
fi



#------
# Rust
#------

if [[ ! "$PATH" =~ "cargo/bin" ]] && [[ -d $HOME/.cargo/bin ]] ; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi



#-------
# Misc.
#-------

export EDITOR=vim
