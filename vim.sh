#!/bin/bash

touch ~/.vimrc
mv ~/.vimrc ~/.vimrc.bk
curl -O https://raw.githubusercontent.com/qixingyue/qshells/master/vimrc
mv vimrc ~/.vimrc

echo "==========================="
vim +BundleClean +BundleInstall! +qa
chown $USER ~/.vim/
echo 'down! enjoy it!'
