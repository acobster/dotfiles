
# Grab a file from the remote server and place it in the
# working directory, relative to the Git root.
grab() {
  root=`git root`

  if [ ! -f "$root/.grab/config" ] ; then
    echo "no config found: $root/.grab/config"
    return 1
  fi

  source $root/.grab/config

  base=$(dirname $root/$1)
  if [[ ! -d $base ]] ; then
    mkdir -p $base
  fi

  scp $GRAB_USER@$GRAB_HOST:$GRAB_REMOTE_ROOT/$1 $root/$1
}

# Push up a file (named relative to the Git root) to the corresponding
# place on the remote server
push() {
  root=`git root`

  if [ ! -f "$root/.grab/config" ] ; then
    echo "no config found: $root/.grab/config"
    return 1
  fi

  source $root/.grab/config

  base=$(dirname $root/$1)
  if [[ ! -d $base ]] ; then
    mkdir -p $base
  fi

  scp $root/$1 $GRAB_USER@$GRAB_HOST:$GRAB_REMOTE_ROOT/$1
}

# Grab all files listed in $root/.grab/files
graball() {

  root=`git root`

  if [ ! -f "$root/.grab/files" ] ; then
    echo "no file list found: $root/.grab/files"
    return 1
  fi

  cat $root/.grab/files | while read file; do grab $file; done
}

# Push all files listed in $root/.grab/files
pushall() {

  root=`git root`

  if [ ! -f "$root/.grab/files" ] ; then
    echo "no file list found: $root/.grab/files"
    return 1
  fi

  cat $root/.grab/files | while read file; do push $file; done
}