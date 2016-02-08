#!/bin/bash

__='
Add repositories to sources
'
add_repositories ()
{
    sudo sh -c "echo 'deb http://download.virtualbox.org/virtualbox/debian '$(lsb_release -cs)' contrib non-free' > /etc/apt/sources.list.d/virtualbox.list"

    repositories=(
        mpstark/elementary-tweaks-daily
        brightbox/ruby-ng
    )

    for repository in "${repositories[@]}"
    do
        add-apt-repository ppa:$repository
    done

}

__='
Add repository keys
'
add_repository_keys ()
{
    wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
}

__='
Install by .deb file
'
install_via_package_files()
{
    packages=(
        https://releases.hashicorp.com/vagrant/1.7.4/vagrant_1.7.4_x86_64.deb
    )

    for package in "${packages[@]}"
    do
        dpgk=$(basename $package)
        wget $package -O "/tmp/$dpgk"
        dpgk -i "/tmp/$dpgk"
    done
}

__='
Install all packages
'
install_packages ()
{
    echo "Installing packages"

    sudo apt-get update

    packages=(
        git
        zsh
        google-chrome-stable
        slack-desktop
        xdg-open
        elementary-tweaks
        ruby2.2
        ruby-dev
        make
        gcc
        nodejs
        tmux
        xclip
        synapse
        # PHP Building
        build-essential
        autoconf
        automake
        libtool
        bison
        re2c
        libxml2-dev
        libcurl4-openssl-dev
        libmcrypt-dev
        libedit-dev
        # Vagrant specific
        virtualbox
        ansible   
    )

    for package in "${packages[@]}"
    do
        apt-get install -y $package
    done
}

__='
Install Ruby Gems
'
instal_ruby_gems ()
{
    gems=(
        jekyll --no-rdoc --no-ri
    )

    for gem in "${gems[@]}"
    do
        sudo gem install $gem
    done
}

__='
Install oh-my-zsh
'
install_oh_my_zsh ()
{
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

__='
Install RVM
'
install_rvm ()
{
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | bash -s stable
}

__='
Move my personal dotfiles across
'
move_dotfiles ()
{
    #
}

__='
Install PHP
'
install_php ()
{
    # Get & install php-src

    curl -sS http://getcomposer.org/installer | php

    cd $HOME/ && git clone
}

if [ "$(id -u)" != "0" ]; then
    echo "Sorry, but you need to sudo"
    exit 1
fi

install_packages \
&& install_oh_my_zsh \
&& install_via_package_files \
&& install_packages \
&& install_rvm \
&& instal_ruby_gems \
&& install_oh_my_zsh \
&& move_dotfiles \
&& install_php