#!/bin/bash


yum install zsh -y 
chsh -s /bin/zsh 
yum install git -y 
git clone git://github.com/robbyrussell/oh-my-zsh.git /usr/local/oh-my-zsh

cp /usr/local/oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

sed -i "s/export ZSH=\$HOME\/.oh-my-zsh/\/usr\/local\/oh-my-zsh/" .zshrc 
