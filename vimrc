let vim_plug_just_installed = 0 
let vim_plug_path = expand('~/.vim/autoload/plug.vim')
if !filereadable(vim_plug_path)
    echo "Installing Vim-plug..."
    echo ""
    silent !mkdir -p ~/.vim/autoload
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let vim_plug_just_installed = 1 
endif
if vim_plug_just_installed
    :execute 'source '.fnameescape(vim_plug_path)
endif
call plug#begin('~/.vim/plugged')
call plug#end()


set incsearch
set hlsearch
syntax on
set nu
set tabstop=4
set shiftwidth=4
set expandtab

autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" |  endif
