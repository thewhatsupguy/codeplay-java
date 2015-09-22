#!/bin/bash
###############################################################################
#  Steps to Setup Vagrant                                                     #
#   Install Virtualbox from virtualbox.org                                    #
#	Install Vagrant from vagrantup.com                                        #
#	Create folder named - codeplay                                            #
#	Run Commands inside folder codeplay                                       #
#		vagrant init ubuntu/trusty64                                          #
#		vagrant up                                                            #
#		vagrant ssh                                                           #
#	Run this script inside the Virtual Machine Now                            #
#       sudo time -p ./vagrant_codeplay-java.sh                               #
###############################################################################

HOST="codeplay.thewhatsupguy.in"
TIMEZONE="Asia/Kolkata"

user=$(whoami)
    if [[ "$user" != "root" ]]; then
    echo "please run the script as root"
    exit 1
    fi

usage()
{
    cat << EOF
        usage: $0
EOF
}

#Timezone
sudo bash -c "echo $TIMEZONE > /etc/timezone"
sudo dpkg-reconfigure -f noninteractive tzdata

#PPAs
sudo add-apt-repository ppa:webupd8team/java -y

#update
sudo apt-get update

#Git
sudo apt-get install -y git

#Git Configuration
cmd="
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=36000'
git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
git config --global alias.d difftool
git config --global difftool.prompt false
"
su vagrant <<< "$cmd"
#Screen configuration
su vagrant <<'EOF'
echo "startup_message off"		                    >  /home/vagrant/.screenrc
echo "# Launch 2 screens on startup"		        >>  /home/vagrant/.screenrc
echo "split -v"					                    >>  /home/vagrant/.screenrc
echo "# Have bash login so $PATH will be updated"   >>  /home/vagrant/.screenrc
echo "screen -t Vim bash -l "                       >>  /home/vagrant/.screenrc
echo "focus"                                        >>  /home/vagrant/.screenrc
echo "screen -t terminal bash -l"                   >>  /home/vagrant/.screenrc
echo "# switch focus back to vim"                   >>  /home/vagrant/.screenrc
echo "focus up"                                     >>  /home/vagrant/.screenrc
EOF

#Vim
sudo apt-get install -y vim
sudo apt-get install -y astyle
#Vim Settings

su vagrant <<'EOF'
mkdir -p /home/vagrant/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git /home/vagrant/.vim/bundle/Vundle.vim
echo ""                                 >  /home/vagrant/.vimrc
echo "\"Vundle Begin"                   >> /home/vagrant/.vimrc
echo "set nocompatible"				    >> /home/vagrant/.vimrc
echo "filetype off"				        >> /home/vagrant/.vimrc
echo "set rtp+=~/.vim/bundle/Vundle.vim">> /home/vagrant/.vimrc
echo "call vundle#begin()"			    >> /home/vagrant/.vimrc
echo "Plugin 'VundleVim/Vundle.vim'"    >> /home/vagrant/.vimrc
echo "Plugin 'Chiel92/vim-autoformat'"  >> /home/vagrant/.vimrc
echo "\"Vundle End"                     >> /home/vagrant/.vimrc	
echo "set tabstop=4"                    >> /home/vagrant/.vimrc
echo "set shiftwidth=4"                 >> /home/vagrant/.vimrc
echo "set expandtab"                    >> /home/vagrant/.vimrc
echo "syntax on"	                    >> /home/vagrant/.vimrc
echo ""				                    >> /home/vagrant/.vimrc
vim +PluginInstall +qall
EOF

#Misc
sudo apt-get install -y dpkg-dev

#Set Hostname
echo "$HOST" > /etc/hostname
echo "127.0.0.1 $HOST" >> /etc/hosts

#Get Codebase
su vagrant <<'EOF' 
git clone https://github.com/thewhatsupguy/codeplay-java.git  /home/vagrant/codeplay-java
EOF

#Java
echo debconf shared/accepted-oracle-license-v1-1 select true | \sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | \sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer
sudo apt-get install -y oracle-java8-set-default

#Vagrant Settings
su vagrant <<'EOF'
echo "# -*- mode: ruby -*-"                                             >  /vagrant/Vagrantfile
echo "# vi: set ft=ruby :" 						                        >> /vagrant/Vagrantfile
echo "Vagrant.configure(2) do |config|"  				                >> /vagrant/Vagrantfile
echo "  config.vm.box = \"ubuntu/trusty64\""  				            >> /vagrant/Vagrantfile
echo "  config.vm.network \"private_network\", ip: \"10.10.10.13\""  	>> /vagrant/Vagrantfile
echo "  config.vm.provider \"virtualbox\" do |vb|"                      >> /vagrant/Vagrantfile
echo "      vb.memory = \"1024\""                                       >> /vagrant/Vagrantfile
echo "  end"                                                            >> /vagrant/Vagrantfile
echo "end" 								                                >> /vagrant/Vagrantfile
EOF

sudo apt-get -y install python-pip python-dev
sudo pip install Glances
sudo pip install PySensors
echo "************************************************************************"
echo "******************Ignore setup.py errors********************************"
echo "************************************************************************"

#Unattended Upgrades
sudo apt-get -y install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
sudo sed -i '3 s/^/\n\/\//' /etc/apt/apt.conf.d/50unattended-upgrades
sudo sed -i '3 s/^/\"\*:\*\";/' /etc/apt/apt.conf.d/50unattended-upgrades
sudo sed -i '28 s/^\/\///' /etc/apt/apt.conf.d/50unattended-upgrades


echo "***************************************************************************"
echo "**************************Please restart the machine***********************"
echo "***************************************************************************"
