#!/bin/bash

function installXcodeCLI() {
  xcode-select -p 1>/dev/null
  isXcodeInstalled=$?
  if [ $isXcodeInstalled -eq 2 ];
  then
    echo "Installing xcode tools..."
    xcode-select --install
    echo "== Done =="
  fi
}

function installHomebrew() {
  if ! command -v brew &> /dev/null
  then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "== Done =="
  fi
}

function installAnsible() {
  if ! command -v ansible &> /dev/null
  then
    echo "Installing Ansible..."
    brew install ansible
    echo "== Done =="
  fi
}

export PATH=$PATH:/opt/homebrew/bin

installXcodeCLI
installHomebrew
installAnsible

SCRIPT_DIR=$(dirname "$0")
pushd $SCRIPT_DIR

echo "Installing galaxy collections"
ansible-galaxy collection install community.general
ansible-galaxy collection install drew1kun.fancyfonts

echo "Installing tools"
sudo -n true
if [[ $? -eq 0 ]]
then
    ansible-playbook setup.yml
else
    ansible-playbook --ask-become-pass setup.yml
fi

popd
