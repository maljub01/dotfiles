" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

filetype on
filetype off " Required for vundle. 'filetype on' prevents exiting with a non-zero status on Mac OS X.

" Setup Vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" Required in order to have Vundle manage itself :)
Plugin 'maljub01/vundle'

" NOTE: comments after a Plugin command are not allowed..
" My Bundles:
"
" Original repos on github
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-ragtag'
Plugin 'tpope/vim-rails'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'pangloss/vim-javascript'
Plugin 'kien/ctrlp.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'KurtPreston/vim-autoformat-rails'
Plugin 'mxw/vim-jsx'
Plugin 'duganchen/vim-soy'

Plugin 'rodjek/vim-puppet'

Plugin 'Lokaltog/vim-easymotion'
Plugin 'taq/vim-git-branch-info'
Plugin 'walm/jshint.vim'
Plugin 'gregsexton/MatchTag'

" Vim-scripts repos:
Plugin 'L9'
Plugin 'matchit.zip'
Plugin 'Align'
Plugin 'advantage'

" Non-github repos:
" Plugin 'git://url/for/repo.git'

" Sparkup: a plugin that lets you write HTML faster.
" usage: write HAML-like markup, then press Ctrl-e
" examples:
"   #wrapper.container
"   .container > p.blog-post {First Paragraph} < .container > p.blog-post*3
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
let g:sparkupExecuteMapping = '<c-c>' " Don't use the default mapping.

" Gundo: a plugin for visualizing your undo tree
Plugin 'sjl/gundo.vim'

call vundle#end()
filetype plugin indent on " Required for vundle

set undofile                " Automatically save undo history to an undo file
set undodir=$HOME/.vim/undo " Where to save undo histories
set undolevels=1000         " Max. number of changes that can be undone
set undoreload=1000         " Max. number of lines for saving buffers for undo upon reload

set hidden          " Don't unload buffers when they're abandoned.
set number          " show line numbers
set autoindent      " always set autoindenting on
set incsearch       " do incremental searching

" Automatically read/write changed buffers:
set autoread        " Automatically reload files that have been changed outside of vim
set autowriteall    " Automatically write files when changing buffers

" Check for file changes when moving the cursor, and read/write accordingly.
autocmd CursorMoved * checktime | silent! update

set noswapfile
set nobackup

set wildmenu        " Show a menu for commandline completion

" Patterns to exclude when globbing.
set wildignore+=*/tmp/*
set wildignore+=.git,.svn,CVS
set wildignore+=*.o,*.a,*.class,*.obj,*.so,*~,*.swp,*.zip
set wildignore+=*.log,*.log.*
set wildignore+=*.jpg,*.png,*.xpm,*.gif,*.pdf

" Ignore case if search pattern is all lowercase, case-sensitive otherwise
set ignorecase
set smartcase

" Don't use ignorecase for * and #
:nnoremap * /\C\<<C-R>=expand('<cword>')<CR>\><CR>
:nnoremap # ?\C\<<C-R>=expand('<cword>')<CR>\><CR>

" Tabs
set tabstop=2       " number of spaces that each tab counts for.
set shiftwidth=2    " use 2 spaces for each indentation.
set expandtab       " use spaces instead of tabs.

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " remove all trailing whitespaces before saving files that match the pattern
  " in $my_file_types.
  let $my_filetypes = '*.{c,c??,h,h??,haml,html,java,js,php,rb,sass}'
  autocmd BufWritePre $my_filetypes :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END
endif " has("autocmd")

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set ruler    " show the position (line #,column #) of the cursor all the time

" In many terminal emulators the mouse works just fine - so if it's available, enable it.
if has('mouse')
  set mouse=a

  if exists("$TMUX")
    " This makes copy/pasting from vim inside tmux easier.
    set mouse=""
  endif
endif

set history=1000   " how many lines of command line history to keep
set showcmd        " display incomplete commands

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

set cursorline
set laststatus=2
set statusline=%F%m%r%h%w\ [%l/%L,\ %v][%p%%]%=%#StatusLineNC#\ Git\ %#ErrorMsg#\ %{GitBranchInfoTokens()[0]}\ %#StatusLine#

let g:clipbrdDefaultReg = '+'

colorscheme advantage

let NERDTreeShowBookmarks=1
map <F2> :tabnew .<CR>

nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
nnoremap <C-h> gT
nnoremap <C-l> gt

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
endif

" Commands to open new files that are in the same directory as the one
" currently being edited
let mapleader=','
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
map <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>et :tabnew <C-R>=expand("%:p:h") . "/" <CR>

" vimgrep for occurances of current word
map <F3> :execute "noautocmd vimgrep /" . expand("<cword>") . "/gj **/*." .  expand("%:e") <Bar> cw<CR>

" increment/decrement letters as well as numbers
set nf=octal,hex,alpha

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

" Highlight trailing whitespace.
:highlight TrailingWhitespace ctermbg=red guibg=red
:au InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
:au InsertLeave * match TrailingWhitespace /\s\+$/

" Use JSXHint for JSX syntax checking
let g:syntastic_javascript_checkers = ['jsxhint']

" Use C++11
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
