
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
  echo $(whoami)@$(hostname) \
    | sed 's/ctamayo@ctamayo-sitecrafting/⚙/' \
    | sed 's/acobster@Tomato.domain/🍅/' \
    | sed 's/acobster@CobyTamsMacBook.domain/🍅/' \
    | sed 's/tamayo@toast/🍅/'

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
    s='🐦 '
  else
    s='\$'
  fi

  echo "$s"
  return 0
}

__git_replacements() {
  git_prompt=''

  GIT_PS1_SHOWUNTRACKEDFILES=1
  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWSTASHSTATE=1

  git_prompt="\$(__git_ps1)"

  # abbreviate git branch names!
  git_prompt="\$(echo $git_prompt | sed 's/feature\\//✔ /')"
  git_prompt="\$(echo $git_prompt | sed 's/experiment\\//🔬 /')"
  git_prompt="\$(echo $git_prompt | sed 's/bugfix\\//🐛 /')"
  git_prompt="\$(echo $git_prompt | sed 's/test\\//❔ /')"

  echo $git_prompt
}
