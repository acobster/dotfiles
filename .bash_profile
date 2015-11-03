# If not running interactively, don't do anything
[ -z "$PS1" ] && return


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
# Git
#---------

# Git prompt
if [ -f ~/dotfiles/git-prompt.bash ]; then
	GIT_PS1_SHOWUNTRACKEDFILES=1
	GIT_PS1_SHOWDIRTYSTATE=1
	GIT_PS1_SHOWSTASHSTATE=1
	source ~/dotfiles/git-prompt.bash
	export PS1='\h\[\e[00m\]:\[\e[1;31m\]$(__git_ps1) \[\e[01;32m\]\w\[\e[00m\] \$ ' 
fi

# Git completion
if [ -f ~/dotfiles/gitcompletion.bash ]; then
	source ~/dotfiles/gitcompletion.bash
fi


#---------
# History
#---------

# force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend


#---------
# Rubies
#---------

# set up rbenv shims
if [[ !  "$PATH" =~ "rbenv" ]] ; then
	echo 'Prepending ~/.rbenv/bin to PATH'
	export PATH="$HOME/.rbenv/bin:$PATH"
fi
eval "$(rbenv init -)"


