#!/usr/bin/env bash
# Call this script by using:
#   source <(curl -L https://raw.githubusercontent.com/MissionCriticalCloud/bubble-cookbook/master/test/localinstall/install.sh)

yum install -y git vim curl

# Fix for sudo/chef, do not require rtty
sed 's/\(^Defaults[ \t]*requiretty\)/#\1/g' -i /etc/sudoers

# Install ChefDK
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -c current -P chefdk
eval "$(chef shell-init bash)"
# Install kitchen-localhost gem/plugin
chef gem install kitchen-localhost

# Git
git clone https://github.com/MissionCriticalCloud/bubble-cookbook.git

# Use the specific kitchen file for convergence
cd bubble-cookbook/
export KITCHEN_LOCAL_YAML=.kitchen.localhost.yml

echo
echo Execute following steps to start installation
echo
echo 1. Edit test/fixtures/data_bags/users/example.json
echo      Change \"id\" and \"ssh_keys\" to your desired username and public-key
echo
echo After this, return to `pwd` and
echo 2. run: kitchen converge
echo 3. reboot \(essential!\)
echo
