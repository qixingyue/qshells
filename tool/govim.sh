#! /bin/sh
echo "backup /etc/vimrc"

cp /etc/vimrc /etc/vimrc_backup

git clone https://github.com/gmarik/vundle.git /usr/share/vim/vimfiles/bundle/vundle

f=$(cat<<EOF>>/etc/vimrc
"-------------------start custom config for golang------------------------"
set nu
filetype indent on
set shiftwidth=4
set softtabstop=4
set tabstop=4

" for vundle
set rtp+=/usr/share/vim/vimfiles/bundle/vundle/  
call vundle#rc('/usr/share/vim/vimfiles/bundle/')  
Bundle 'gmarik/vundle'

" plugin for go
Bundle 'dgryski/vim-godef'
Bundle 'Blackrush/vim-gocode'
Bundle 'majutsushi/tagbar'
Bundle 'cespare/vim-golang'

" auto format go file
autocmd BufWritePre *.go :Fmt

" for auto complete
imap <C-j> <C-x><C-o>

" for tags
nmap <F8> :TagbarToggle<CR>
let g:tagbar_type_go = {
			\ 'ctagstype' : 'go',
			\ 'kinds'     : [
			\ 'p:package',
			\ 'i:imports:1',
			\ 'c:constants',
			\ 'v:variables',
			\ 't:types',
			\ 'n:interfaces',
			\ 'w:fields',
			\ 'e:embedded',
			\ 'm:methods',
			\ 'r:constructor',
			\ 'f:functions'
			\ ],
			\ 'sro' : '.',
			\ 'kind2scope' : {
			\ 't' : 'ctype',
			\ 'n' : 'ntype'
			\ },
			\ 'scope2kind' : {
			\ 'ctype' : 't',
			\ 'ntype' : 'n'
			\ },
			\ 'ctagsbin'  : 'gotags',
			\ 'ctagsargs' : '-sort -silent'
			\ }
"-------------------end custom config for golang------------------------"
EOF
)

go get -u github.com/jstemmer/gotags

echo "Please open vim and use command \":BundleInstall\" install other plugin"
sleep 5
