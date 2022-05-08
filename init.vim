set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

call plug#begin()
  Plug '/opt/homebrew/bin/fzf'
  Plug 'preservim/nerdtree'
call plug#end()
