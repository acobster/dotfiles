# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export EDITOR=nvim


#---------
# PROMPT
#---------

#
# Web-environment-based prompt:
# put your LIVE_DIRS array definition inside a file at ~/.live.env, e.g.:
#
#   LIVE_DIRS=(/var/www/example.com /var/www/example2.com)
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
  echo $(whoami)@$(hostname) \
    | sed 's/tamayo@amperpad/⚡/' \
    | sed 's/tamayo@damperon/⚡/' \
    | sed 's/(amperon)/🐍/' \
    | sed 's/coby@devbox-frontend/⛈ /' \
    | sed 's/tamayo@toast/🍅/' \
    | sed 's/tamayo@nixpad/🍅/' \
    | sed 's/tamayo@clementine/🍊/' \
    | sed 's/tamayo@nixtest/🤓/'

  return 0
}

__ps1_symbol() {
  if [[ "$NIX_DEVELOP" ]] ; then
    echo 'λ'
    return 0
  fi
  if [[ $VIRTUAL_ENV ]] ; then
    echo '🐍'
    return 0
  fi

  # Easter eggs!
  # strip leading zero from mmdd date
  dt=$(date '+%m%d' | sed 's/^0//')

  # same for time
  t=$(date '+%H' | sed 's/^0//')

  if [[ $dt == '115' ]] ; then
    s='🐦'
  elif [[ $dt == '201' ]] ; then
    s='🍆'
  elif [[ $dt == '210' ]] ; then
    s='🌱'
  elif [[ $dt == '314' ]] ; then
    s='π'
  elif [[ $dt == '316' ]] ; then
    s='⚾️'
  elif [[ $dt == '317' ]] ; then
    s='🍀'
  elif [[ $dt == '422' ]] ; then
    s='🌎'
  elif [[ $dt == '528' ]] ; then
    s='🤓'
  elif [[ $dt == '624' ]] ; then
    s='👨'
  elif [[ $dt == '628' ]] ; then
    s='τ'
  elif [[ $dt == '809' ]] ; then
    s='🍕'
  elif [[ $dt == '817' ]] ; then
    s='💖'
  elif [[ $dt == '1031' ]] ; then
    s='🎃'
  elif [[ $dt == '1231' ]] || [[ $dt == '101' ]] ; then
    s='🎉'
  elif [[ $dt -gt 1201 ]] ; then
    s='🎄'
  else
    s='$'
  fi

  echo "$s"
  return 0
}

__compose_ps1() {
  MAGENTA='\e[1;35m'
  GREEN='\e[01;32m'

  BOLD='$(tput bold)'
  RESET='$(tput sgr0)'

  # Git prompt
  local git_prompt
  git_prompt=''

  if [[ -f ~/dotfiles/git/git-prompt.bash ]]; then
    GIT_PS1_SHOWUNTRACKEDFILES=1
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    source ~/dotfiles/git/git-prompt.bash
    git_prompt="\$(__git_ps1)"

    # abbreviate git branch names!
    git_prompt="\$(echo $git_prompt | sed 's/feature\\//✔ /')"
    git_prompt="\$(echo $git_prompt | sed 's/experiment\\//🔬 /')"
    git_prompt="\$(echo $git_prompt | sed 's/bugfix\\//🐛 /')"
    git_prompt="\$(echo $git_prompt | sed 's/hotfix\\//🔥 /')"
    git_prompt="\$(echo $git_prompt | sed 's/refactor\\//𝚫 /')"
    git_prompt="\$(echo $git_prompt | sed 's/test\\//❔ /')"
  fi

  symbol="\$(__ps1_symbol)"

  export PS1="\$(__user_host_ps1) \[$BOLD\]\[$MAGENTA\]${git_prompt} \[$GREEN\]\$(__cwd_ps1)\$(__env_ps1)\[$RESET\] ${symbol} "
}

__compose_ps1



#---------
# PATH
#---------

if [[ -d "$HOME/bin" ]] && ! [[ $PATH =~ ":${HOME}\/bin:" ]] ; then
  export PATH=~/bin:$PATH
fi

if [[ ! $PATH =~ "dotfiles/bin:" ]] ; then
  export PATH=$HOME/dotfiles/bin:$PATH
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



#----------------------------
# Bash functions and aliases
#----------------------------

# Load common aliases
if [[ -f ~/dotfiles/bash/.aliases ]] ; then
	source ~/dotfiles/bash/.aliases
fi

# Load machine-specific aliases, too!
if [[ -f ~/.aliases ]] ; then
  source ~/.aliases
fi

# Load common functions
if [[ -f ~/dotfiles/bash/.functions ]] ; then
  source ~/dotfiles/bash/.functions
fi

# Load machine-specific functions
if [[ -f ~/.functions ]] ; then
  source ~/.functions
fi



#--------
# Colors
#--------

#
# Provide an ergonomic way to switch between light/dark solarized themes
#

if [[ -f "${HOME}/.dir_colors/theme" ]] ; then
  export SOLARIZED_THEME=$(cat "${HOME}/.dir_colors/theme")
else
  # default to dark
  export SOLARIZED_THEME=dark
fi

# Set an environment variable that tools like Vim can detect
if [[ -f "${HOME}/.dir_colors/solarized.ansi-${SOLARIZED_THEME}" ]] ; then
  eval `dircolors "${HOME}/.dir_colors/solarized.ansi-${SOLARIZED_THEME}"`
fi



#---------
# Git
#---------

# Git completion
if [[ -f ~/dotfiles/git/git-completion.bash ]]; then
	source ~/dotfiles/git/git-completion.bash
fi



#--------
# Search
#--------

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

if command -v fzf-share >/dev/null ; then
  source "$(fzf-share)/key-bindings.bash"
  source "$(fzf-share)/key-bindings.bash"
fi



#--------
# Window
#--------

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize



#--------
# Direnv
#--------

if [[ $(which direnv) ]] ; then
  eval "$(direnv hook bash)"
fi



#--------
# NVM
#--------

if [[ -d ~/.nvm ]] ; then
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi



#--------
# PYENV
#--------


if [[ -d ~/.pyenv ]] ; then
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi
