" -*- vim: set sts=2 sw=2 et fdm=marker: -------------  vim modeline -*-

" Basic Settings -------------------------------------- {{{1
syntax on
set nocompatible
filetype plugin indent on
let g:mapleader = " "

set sw=2 sts=2 et nu sr
set diffopt=filler,context:3
set display=lastline
set hidden
set hlsearch
if has('nvim')
  set inccommand=nosplit
endif
set incsearch
set nrformats=hex
set ruler
set showcmd
set isfname-==
set shortmess+=s
set nostartofline
set synmaxcol=1000
set tags=./tags,tags,./../tags,./../../tags,./../../../tags
set title
set whichwrap=b,s,[,]
set wildcharm=<tab>
set wildmenu
set wildmode=list:longest,list:full
set wildignore=*.o,*.bak,*.byte,*.native,*~,*.sw?,*.aux,*.toc,*.hg,*.git,*.svn,*.hi,*.so,*.a,*.pyc,*.aux,*.toc,*.exe
"set autochdir
set winaltkeys=no
set scrolloff=3 scrolljump=5
set showbreak=↪
set breakindent
set sidescroll=10 sidescrolloff=10
set switchbuf=useopen
"set ignorecase smartcase
set timeoutlen=600
set ttimeoutlen=0
set matchpairs=(:),[:],{:},<:>,':',":"
set laststatus=2
set cursorline
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

set backup
set backupdir=~/.vimtmp/backup//
set directory=~/.vimtmp/swap//
set noswapfile
if has('persistent_undo')
  set undofile
  set undolevels=200
  set undodir=~/.vimtmp/undo
end
set viminfo='100,:10000,<50,s10,h,!

" set backspace=indent,eol,start
set history=1000

set fileencodings=ucs-bom,utf8,cp936,gbk,big5,euc-jp,euc-kr,gb18130,latin1

if executable('par')
  set formatprg="par rTbgqR B=.,?_A_a Q=_s>|"
el
  set formatprg=fmt
en
set formatoptions+=nj " support formatting of numbered lists

" tabs and spaces
set listchars+=tab:▸\ ,trail:⋅,nbsp:␣
" eols and others
set listchars+=eol:¬,extends:»,precedes:«

" highlight columns after 'textwidth'
set colorcolumn=+1,+2,+4,+5,+6,+7,+8

if has('mouse')
  set mouse=a
endif

if has("gui_running")
  set guiheadroom=20
  " Ctrl-F12 Toggle Menubar and Toolbar
  nnoremap <silent> <C-F12> :
    \ if &guioptions =~# 'T' <Bar>
      \ set guioptions-=T <Bar>
      \ set guioptions-=m <Bar>
    \ else <Bar>
      \ set guioptions+=T <Bar>
      \ set guioptions+=m <Bar>
    \ endif<CR>

  set guioptions-=T
  set guioptions-=m
  " no scroll bars
  set guioptions-=r
  set guioptions-=L
endif

" Status Line ----------------------------------------- {{{1
set laststatus=2

set statusline=%#ColorColumn#%2f              " buffer number
"set statusline+=%*»                           " separator
"set statusline+=%<                            " truncate here
"set statusline+=%*»                           " separator
set statusline+=%*-                           " separator
set statusline+=%#DiffText#%m                 " modified flag
set statusline+=%r                            " readonly flag
"set statusline+=%*»                           " separator
set statusline+=%#CursorLine#(%l/%L,%c)%*»    " line no./no. of lines,col no.
set statusline+=%=«                           " right align the rest
set statusline+=%#Cursor#%02B                 " value of current char in hex
set statusline+=%*-                           " separator
set statusline+=%#ErrorMsg#%o                 " byte offset
set statusline+=%*-                           " separator
set statusline+=%#Title#%y                    " filetype
set statusline+=%*-                           " separator
set statusline+=%#ModeMsg#%3p%%               " % through file in lines
set statusline+=%*                            " restore normal highlight
" Fonts ----------------------------------------------- {{{1
if has("gui_running")
  " Envy Code R
  " http://damieng.com/blog/2008/05/26/envy-code-r-preview-7-coding-font-released
  " set guifont=Monaco\ 15
  " set guifont=Inconsolata\ 15
  " set guifont=Monofur\ 16
  set guifont=Fantasque\ Sans\ Mono\ 18
  set guifontwide=Source\ Han\ Sans\ 15
endif
if has('nvim')
  " Neovim-qt Guifont command
  "command -nargs=? Guifont call rpcnotify(0, 'Gui', 'SetFont', "<args>") | let g:Guifont="<args>"
  "Guifont Fantasque Sans Mono:h18
endif
