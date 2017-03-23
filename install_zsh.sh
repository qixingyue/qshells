#!/bin/bash


yum install zsh -y 
chsh -s /bin/zsh 
yum install git -y 
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

