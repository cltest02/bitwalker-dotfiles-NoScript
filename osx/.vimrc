set nocompatible | filetype indent plugin on | syn on

"""""""""""""""""""
" Vim Addon Manager
"""""""""""""""""""
fun! EnsureVamIsOnDisk(plugin_root_dir)
  " windows users may want to use http://mawercer.de/~marc/vam/index.php
  " to fetch VAM, VAM-known-repositories and the listed plugins
  " without having to install curl, 7-zip and git tools first
  " -> BUG [4] (git-less installation)
  let vam_autoload_dir = a:plugin_root_dir.'/vim-addon-manager/autoload'
  if isdirectory(vam_autoload_dir)
    return 1
  else
    call mkdir(a:plugin_root_dir, 'p')
    execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.
	    \  shellescape(a:plugin_root_dir, 1).'/vim-addon-manager'
    " VAM runs helptags automatically when you install or update 
    " plugins
    exec 'helptags '.fnameescape(a:plugin_root_dir.'/vim-addon-manager/doc')
    return isdirectory(vam_autoload_dir)
  endif
endfun

fun! SetupVAM(plugin_dir)
  " Set advanced options like this:
  " let g:vim_addon_manager = {}
  " let g:vim_addon_manager.key = value
  "     Pipe all output into a buffer which gets written to disk
  " let g:vim_addon_manager.log_to_buf =1

  " Example: drop git sources unless git is in PATH. Same plugins can
  " be installed from www.vim.org. Lookup MergeSources to get more control
  " let g:vim_addon_manager.drop_git_sources = !executable('git')
  " let g:vim_addon_manager.debug_activation = 1

  " VAM install location:
  let c = get(g:, 'vim_addon_manager', {})
  let g:vim_addon_manager = c
  let c.plugin_root_dir = expand(a:plugin_dir, 1)
  if !EnsureVamIsOnDisk(c.plugin_root_dir)
    echohl ErrorMsg | echomsg "No VAM found!" | echohl NONE
    return
  endif
  let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'

  " Tell VAM which plugins to fetch & load:
  " call vam#ActivateAddons([], {'auto_install' : 0})
  " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})
  " Also See "plugins-per-line" below

  " Addons are put into plugin_root_dir/plugin-name directory
  " unless those directories exist. Then they are activated.
  " Activating means adding addon dirs to rtp and do some additional
  " magic

  " How to find addon names?
  " - look up source from pool
  " - (<c-x><c-p> complete plugin names):
  " You can use name rewritings to point to sources:
  "    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
  "    ..ActivateAddons(["github:user/repo", .. => github://user/repo
  " Also see section "2.2. names of addons and addon sources" in VAM's documentation
endfun

""""""""""""""""""""""
" Plugin Configuration
""""""""""""""""""""""
call SetupVAM('~/.vim/bundle')

let g:vim_addon_manager.log_to_buf = 1
call vam#ActivateAddons([])

" Color Schemes
" 'blerins/flattown'
" 'zefei/cake16'
" 'duythinht/vim-coffee'
" 'tomasr/molokai'
" 'altercation/vim-colors-solarized'
" 'ajh17/Spacegray.vim'
" 'CruizeMissile/Revolution.vim'
" 'gertjanreynaert/cobalt2-vim-theme'
VAMActivate github:abra/vim-abra
" General plugins
VAMActivate github:tpope/vim-surround
VAMActivate github:kien/ctrlp.vim
VAMActivate github:scrooloose/nerdtree
VAMActivate github:nathanaelkane/vim-indent-guides
VAMActivate github:tpope/vim-fugitive
" UI plugins
VAMActivate github:bling/vim-airline
" Language support
VAMActivate github:othree/html5.vim
VAMActivate github:pangloss/vim-javascript
VAMActivate github:tpope/vim-markdown
VAMActivate github:elixir-lang/vim-elixir
VAMActivate github:jimenezrick/vimerl

"""""""""""""""""""""""
" General Configuration
"""""""""""""""""""""""

" Change shell
set shell=bash " Vim expects a POSIX-compliant shell, which Fish (my default shell) is not

" UI
try
  colorscheme abra
catch
endtry
set guifont=Fantasque\ Sans\ Mono\ Regular:h14
" Set extra options when running in GUI mode
if has("gui_running")
  set guioptions-=T
  set guioptions-=e
  set t_Co=256
  set guitablabel=%M\ %t
endif
set lsp=5
set linespace=0

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif
" Switch from block-cursor to vertical-line-cursor when going into/out of
" insert mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" highlight current line
"au WinLeave * set nocursorline nocursorcolumn
"au WinEnter * set cursorline cursorcolumn
"set cursorline cursorcolumn

" set leader to ,
let mapleader=","
let g:mapleader=","

" general settings
set history=1000
set undolevels=1000
set nocompatible
set backspace=indent,eol,start " More powerful backspacing
set report=0                   " always report number of lines changed
set nowrap                     " dont wrap lines
set scrolloff=5                " 5 lines above/below cursor when scrolling
set number                     " show line numbers
set showmatch                  " show matching bracket (briefly jump)
set showcmd                    " show typed command in status bar
set title                      " show file in titlebar
set laststatus=2               " use 2 lines for the status bar
set matchtime=2                " show matching bracket for 0.2 seconds
set matchpairs+=<:>            " specially for html
set shortmess+=I               " hide the launch screen
set clipboard=unnamed          " normal OS clipboard interaction
set autoread                   " automatically reload files changed outside of Vim
set ignorecase                 " Ignore case when searching
set smartcase                  " When searching try to be smart about cases
set hlsearch                   " Highlight search results
set incsearch                  " Makes search act like search in modern browsers
set lazyredraw                 " Don't redraw while executing macros (good performance config)
set magic                      " For regular expressions turn magic on

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" wildmenu
set wildmenu                   " make tab completion for files/buffers act like bash
set wildmode=list:full         " show a list when pressing tab and complete
" first full match
set wildignore=*.o,*~,*.pyc,*.swp,*.bak,*.class
if has("win16") || has("win32")
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
  set wildignore+=.git\*,.hg\*,.svn\*
endif

" indentation
" Use spaces instead of tabs
set expandtab
" Be smart when using tabs
set smarttab
" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
" auto indent
set ai
" smart indent
set si

" disable sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" encoding
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,big5,gb2312,latin1

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" w!! to sudo & write a file
cmap w!! %!sudo tee >/dev/null %

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = "luna"
let g:airline_enable_branch = 1

" ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
" Ignore common directories
let g:ctrlp_custom_ignore = {
  \ 'dir': 'node_modules\|bower_components',
  \ }

" Close vim if last open buffer is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Use The Silver Searcher over grep, iff possible
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Conflict markers {{{
" highlight conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Shortcut for toggling display of invisibles
nmap <leader>l :set list!<CR>

" Use the same symbols as textmate for tabstops and EOLs
set listchars=nbsp:·,tab:▸\ ,eol:¬,trail:·,extends:>,precedes:<

" Toggle search highlighting
nmap <leader>h :set hlsearch!<CR>
