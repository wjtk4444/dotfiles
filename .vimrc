" enter the current millennium
set nocompatible

syntax enable
filetype plugin on

" recursive search in subdirectories
set path+=**

set wildmenu

" max history entries
set history=1000

" show line numbers
set number
set relativenumber

" highlight 81 column
"set textwidth=80
"set colorcolumn=+1,+2"

" search
set ignorecase
set smartcase
set incsearch

" don't redraw while executing macros
"set lazyredraw

" enable regex
set magic

" show matching brackets
set showmatch

set encoding=utf-8

" disable backup
set nobackup
set nowb
set noswapfile

" use spaces instead of tabs
set expandtab
set smarttab

" set tab width
set shiftwidth=4
set tabstop=4

" autoindent, smartindent
set ai
set si

" show commands as you type
set sc

" word wrap
set wrap
set linebreak

" always show status line
set laststatus=2

" folding
set foldenable
set foldmethod=syntax

" enable dictionaries
set spelllang=en,pl

" open splits in more natural postions
set splitbelow
set splitright

" list of whitespace characters to display 
" (requires calling :set list manually)
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" allow expanding block past text
set virtualedit=block

" custom commands
" read template file
com -nargs=1 -complete=customlist,TemplateComplete Template :0 read ~/.vim/templates/<args>
fun! TemplateComplete(A, L, P)
  let l:basepath = expand('~/.vim/templates/')
  let l:basepathlen = len(l:basepath)
  return map(getcompletion(l:basepath . a:A, 'file'), 'v:val[l:basepathlen : ]')
endfun

" Add argument (can be negative, default 1) to global variable i.
" Return value of i before the change.
function Increment(...)
  let result = g:i
  let g:i += a:0 > 0 ? a:1 : 1
  return result
endfunction

" custom key bindings
map <F5> :w <CR> :cexpr system('make') <CR> 

" quicklist navigation
map <C-n> :cn <CR>
map <C-p> :cp <CR>

" switch tabs using F7 and F8
map <F7> :tabp <CR>
map <F8> :tabn <CR>

"inoremap " ""<left>
"inoremap ' ''<left>
"inoremap ( ()<left>
"inoremap [ []<left>
"inoremap { {}<left>
"inoremap {<CR> {<CR>}<ESC>O
"inoremap {;<CR> {<CR>};<ESC>O

" filetype specific options
autocmd FileType markdown,mkd,rmd,tex,latex,plaintex setlocal spell "filetype=plaintex 
