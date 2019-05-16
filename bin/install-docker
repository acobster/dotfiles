#!/usr/bin/env bash

#
# Install Docker Community Edition per official instructions:
# https://docs.docker.com/install/linux/docker-ce/debian/#install-docker-ce-1
#

sudo apt-get update
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg2 \
  software-properties-common

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88
echo 'does the key match? 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88'
read -p '(yes/no) ' CONFIRM

if ! [[ $CONFIRM = 'yes' ]] ; then
  echo 'key mismatch; bailing'
  exit 1
fi

# add Docker's Ubuntu apt repository
# https://stackoverflow.com/questions/41133455/docker-repository-does-not-have-a-release-file-on-running-apt-get-update-on-ubun#43639310
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  xenial \
  stable"

sudo apt-get update

sudo apt-get install -y docker-ce

