# If not running interactively, don't do anything
[ -z "$PS1" ] && return


#---------
# PROMPT
#---------

source ~/dotfiles/prompt.bash

__compose_ps1() {
  MAGENTA='\e[1;35m'
  GREEN='\e[01;32m'

  BOLD='$(tput bold 1)'
  RESET='$(tput sgr0)'

  # Git prompt
  local git_prompt
  git_prompt="$(__git_replacements)"

  export PS1="\$(__user_host_ps1) \[$BOLD\]\[$MAGENTA\]${git_prompt} \[$GREEN\]\$(__cwd_ps1)\$(__env_ps1)\[$RESET\] $(__ps1_symbol) "
}

__compose_ps1


#---------
# PATH
#---------

if [[ -d "${HOME}/apps" ]] && ! [[ $PATH =~ "${HOME}/apps:" ]] ; then
  export PATH=$HOME/apps:$PATH
fi

if [[ -d "$HOME/bin" ]] && ! [[ $PATH =~ ":${HOME}\/bin:" ]] ; then
  export PATH=~/bin:$PATH
fi

if [[ -d "/usr/local/mysql/bin" ]] && ! [[ $PATH =~ ":mysql\/bin:" ]] ; then
  export PATH=/usr/local/mysql/bin:$PATH
fi

if [[ ! $PATH =~ "dotfiles/bin:" ]] ; then
  export PATH=$HOME/dotfiles/bin:$PATH
fi

if [[ -d "${HOME}/.linkerd2/bin" ]] && ! [[ $PATH =~ "${HOME}/.linkerd2/bin:" ]] ; then
  export PATH=$HOME/.linkerd2/bin:$PATH
fi

# https://docs.radicle.xyz/docs/getting-started
if [[ -d "${HOME}/.radicle/bin" ]] && ! [[ $PATH =~ "${HOME}/.radicle/bin:" ]] ; then
  export PATH=$HOME/.radicle/bin:$PATH
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

#
# Provide an ergonomic way to switch between light/dark solarized themes
#

if [[ -f "${HOME}/.dir_colors/theme" ]] ; then
  export GNOME_TERMINAL_SOLARIZED_THEME=$(cat "${HOME}/.dir_colors/theme")
else
  # default to dark
  export GNOME_TERMINAL_SOLARIZED_THEME=dark
fi

# Set an environment variable that tools like Vim can detect
if [[ -f "${HOME}/.dir_colors/dircolors.${GNOME_TERMINAL_SOLARIZED_THEME}" ]] ; then
  eval `dircolors "${HOME}/.dir_colors/dircolors.${GNOME_TERMINAL_SOLARIZED_THEME}"`
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
# Git
#---------

# Alias git -> hub
if [[ $(which hub) ]] ; then
  alias git='hub'
fi

# Global .gitignore
if [[ -z $(git config --global core.excludesfile) ]] ; then
  git config --global core.excludesfile '~/.gitignore'
fi

# Alias: git st
if [[ -z $(git config --global alias.st) ]] ; then
  git config --global alias.st 'status'
fi

# Alias: git churn
if [[ -z $(git config --global alias.churn) ]] ; then
  git config --global alias.churn '!git-churn'
fi

# Alias: git sh
if [[ -z $(git config --global alias.sh) ]] ; then
  git config --global alias.sh 'stash'
fi

# Alias: git pop
if [[ -z $(git config --global alias.pop) ]] ; then
  git config --global alias.pop 'stash pop'
fi

# Alias: git local
if [[ -z $(git config --global alias.local) ]] ; then
  git config --global alias.local '!git l $(git current-remote-branch)..HEAD'
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
  git config --global alias.ha 'add --all --patch'
fi

# Alias: git co
if [[ -z $(git config --global alias.co) ]] ; then
  git config --global alias.co 'checkout'
fi

# Alias: git ci
if [[ -z $(git config --global alias.ci) ]] ; then
  git config --global alias.ci 'commit'
fi

# Alias: git m
if [[ -z $(git config --global alias.m) ]] ; then
  git config --global alias.m 'commit -m'
fi

# Alias: git cam
if [[ -z $(git config --global alias.cam) ]] ; then
  git config --global alias.cam 'commit -am'
fi

# Alias: git amend
if [[ -z $(git config --global alias.amend) ]] ; then
  git config --global alias.amend 'commit --amend'
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

# Alias: git current-branch
if [[ -z $(git config --global alias.current-branch) ]] ; then
  git config --global alias.current-branch 'rev-parse --abbrev-ref HEAD'
fi

# Alias: git cb
if [[ -z $(git config --global alias.cb) ]] ; then
  git config --global alias.cb 'rev-parse --abbrev-ref HEAD'
fi

# Alias: git current-remote-branch
if [[ -z $(git config --global alias.current-remote-branch) ]] ; then
  git config --global alias.current-remote-branch '!echo origin/$(git current-branch)'
fi

# Alias: git cr
if [[ -z $(git config --global alias.cr) ]] ; then
  git config --global alias.cr '!echo origin/$(git current-branch)'
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
if [[ -z $(git config --global alias.ls) ]] ; then
  git config --global alias.ls 'log --pretty="%s"'
fi
if [[ -z $(git config --global alias.l) ]] ; then
  git config --global alias.l '!. ~/.githelpers && pretty_git_log'
fi
if [[ -z $(git config --global alias.o) ]] ; then
  git config --global alias.o 'log --oneline'
fi
if [[ -z $(git config --global alias.links) ]] ; then
  git config --global alias.la '!git-links'
fi
if [[ -z $(git config --global alias.la) ]] ; then
  git config --global alias.la '!git l --all'
fi

# Alias: git continue
if [[ -z $(git config --global alias.continue) ]] ; then
  git config --global alias.continue 'rebase --continue'
fi

# Alias: git d1
if [[ -z $(git config --global alias.d1) ]] ; then
  git config --global alias.d1 'diff HEAD~2 HEAD~1'
fi

# Alias: git d2
if [[ -z $(git config --global alias.d2) ]] ; then
  git config --global alias.d2 'diff HEAD~3 HEAD~2'
fi

# Alias: git d3
if [[ -z $(git config --global alias.d3) ]] ; then
  git config --global alias.d3 'diff HEAD~3 HEAD~2'
fi

# Alias: git d4
if [[ -z $(git config --global alias.d4) ]] ; then
  git config --global alias.d4 'diff HEAD~5 HEAD~4'
fi

# Alias: git d5
if [[ -z $(git config --global alias.d5) ]] ; then
  git config --global alias.d5 'diff HEAD~6 HEAD~5'
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

# Alias: git l6
if [[ -z $(git config --global alias.l6) ]] ; then
  git config --global alias.l6 '!. ~/.githelpers && pretty_git_log -6'
fi

# Alias: git l7
if [[ -z $(git config --global alias.l7) ]] ; then
  git config --global alias.l7 '!. ~/.githelpers && pretty_git_log -7'
fi

# Alias: git l8
if [[ -z $(git config --global alias.l8) ]] ; then
  git config --global alias.l8 '!. ~/.githelpers && pretty_git_log -8'
fi

# Alias: git l9
if [[ -z $(git config --global alias.l9) ]] ; then
  git config --global alias.l9 '!. ~/.githelpers && pretty_git_log -9'
fi

# Alias: git l10
if [[ -z $(git config --global alias.l10) ]] ; then
  git config --global alias.l10 '!. ~/.githelpers && pretty_git_log -10'
fi

# Alias: git rbi
if [[ -z $(git config --global alias.rbi) ]] ; then
  git config --global alias.rbi 'rebase -i'
fi


# Git completion
if [ -f ~/dotfiles/git-completion.bash ]; then
	source ~/dotfiles/git-completion.bash
fi


# Search

if [[ -f ~/.fzf.bash ]] ; then
  source ~/.fzf.bash
  export FZF_DEFAULT_COMMAND="find . -path '*/\.*' -type d -prune -o -type f -print -o -type l -print 2> /dev/null | sed s/^..//"

  if [[ !  "$PATH" =~ ".fzf/bin" ]] ; then
    export PATH="$PATH:$HOME/.fzf/bin"
  fi
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

if [[ -f ~/dotfiles/wp-completion.bash ]] ; then
	source ~/dotfiles/wp-completion.bash
fi



#---------
# Terminus
#---------

if [[ !  "$PATH" =~ "$HOME/vendor/bin" ]] && [[ -d "$HOME/vendor/bin" ]] ; then
  export PATH="$PATH:$HOME/vendor/bin"
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

if [[ -d /usr/local/go ]] ; then
  export GOROOT='/usr/local/go'

  if [[ ! "$PATH" =~ "/usr/local/go/bin:" ]] ; then
    export PATH="/usr/local/go/bin:$PATH"
  fi
fi

if [[ -d "${HOME}/go" ]] ; then
  export GOPATH="${HOME}/go"

  if [[ ! "$PATH" =~ "{$HOME}/go/bin:" ]] ; then
    export PATH="${HOME}/go/bin:$PATH"
  fi
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

export EDITOR=nvim
