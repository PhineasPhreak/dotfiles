" -*- vim: set sts=2 sw=2 et fdm=marker: Modified by PhineasPhreak 

""" Basic Settings """
" Enable syntax highlighting
syntax enable 

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" Enable 256 colors palette in Mate Terminal
if $TERM == 'xterm'
    set t_Co=256
endif

" 'dark' or 'light'; the background color brightness
set background=dark

" Behave very Vi compatible (not advisable)
set nocompatible

filetype plugin indent on
let g:mapleader = " "

set sw=2 sts=2 et nu sr

set diffopt=filler,context:3

set display=lastline

" Hide files in the background instead of closing them
set hidden

" Highlight search results
set hlsearch

" Disable syntax conceal for markdown language
set conceallevel=0

" Makes search act like search in modern browsers
set incsearch

" Interpret octal as decimal when incrementing numbers
"set nrformats=hex

" Always show current position
set ruler

" Show matching brackets when text indicator is over them
set showcmd

" Specifies the characters in a file name
set isfname-==

" List of flags to make messages shorter
set shortmess+=s

" Maximum column to look for syntax items
set synmaxcol=1000

" Set the window’s title, reflecting the file currently being edited
set title

" List of flags specifying which commands wrap to another line
set whichwrap=b,s,[,]

" Like 'wildchar' but can also be used in a mapping
set wildcharm=<tab>

" Turn on the Wild menu
set wildmenu

" Specifies how command line completion works
set wildmode=list:longest,list:full

" Ignore files matching these patterns when opening files based on a glob pattern
set wildignore=*.o,*.bak,*.byte,*.native,*~,*.sw?,*.aux,*.toc,*.hg,*.git,*.svn,*.hi,*.so,*.a,*.pyc,*.aux,*.toc,*.exe,*.DS_Store

" Change to directory of file in buffer
"set autochdir

" No alternative keys
set winaltkeys=no

" Number of screen lines to show around the cursor
set scrolloff=7 scrolljump=5

" String to put before wrapped screen lines
"set showbreak=↪

" Preserve indentation in wrapped text
set breakindent

" Mminimal number of columns to scroll horizontally
set sidescroll=10 sidescrolloff=10

" 'useopen' and/or 'split'; which window to use when jumping
set switchbuf=useopen

" Ignore case when using a search pattern
" Smartcase : override 'ignorecase' when pattern has upper case characters
"set ignorecase smartcase

" Time in msec for 'timeout'
set timeoutlen=600

" Time in msec for 'ttimeout'
set ttimeoutlen=0

" list of pairs that match for the 'x' command
set matchpairs=(:),[:],{:},<:>,':',":"

" 0, 1 or 2; when to use a status line for the last window
set laststatus=2

" Highlight the screen line of the cursor
"set cursorline

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Highlight the screen line of the cursor for GUI
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

" Keep a backup after overwriting a file
"set backup
"set backupdir=~/.vimtmp/backup//
 
set noswapfile
"set directory=~/.vimtmp/swap//

if has('persistent_undo')
  set undofile
  set undolevels=200
  set undodir=~/.vimtmp/undo
end

" Use a swap file for this buffer
set viminfo='100,:10000,<50,s10,h,!

" Set backspace=indent,eol,start
set history=1000

" Character encoding for the current file
set fileencodings=ucs-bom,utf8,cp936,gbk,big5,euc-jp,euc-kr,gb18130,latin1

if executable('par')
  set formatprg="par rTbgqR B=.,?_A_a Q=_s>|"
el
  set formatprg=fmt
en
set formatoptions+=nj " support formatting of numbered lists

" Tabs and spaces
set listchars+=tab:▸\ ,trail:⋅,nbsp:␣
" Eols and others
set listchars+=eol:¬,extends:»,precedes:«

"Hhighlight columns after 'textwidth'
set colorcolumn=+1,+2,+4,+5,+6,+7,+8

" List of flags for using the mouse
if has('mouse')
  set mouse=a
endif

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" Quickly insert an empty new line without entering insert mode
nnoremap <Leader>j o<Esc>
nnoremap <Leader>k O<Esc>

" Statusline for VIM
set statusline=%f\ %h%w%m%r\ %=%(%{&ff}\ %(//%)\ %{''.(&fenc!=''?&fenc:&enc).''}\ %(//%)\ \%y\ %-4.(%)\ %3l,%-2v\ %-2.(%)\ %L\ %-4.(%)\ %P%)\ %-3.(%)

