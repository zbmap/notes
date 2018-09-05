set nocompatible
set ff=unix
set laststatus=2
let mapleader = "\<space>"
let g:mapleader ="\<space>"
set t_Co=256

"vim plug
call plug#begin(expand('~/.vim/plugged'))
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'

Plug 'vim-scripts/indexer.tar.gz'
Plug 'vim-scripts/DfrankUtil'
Plug 'vim-scripts/vimprj'

Plug 'dyng/ctrlsf.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'Valloric/YouCompleteMe'

Plug 'Lokaltog/vim-easymotion'

Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'Shougo/echodoc.vim'
call plug#end()

"ctrlsf
let g:ctrlsf_case_sensitive='yes'
let g:ctrlsf_auto_focus = {
    \ "at": "start"
    \ }
nnoremap <Leader>a :CtrlSF<CR>
nnoremap <Leader>r :CtrlSF<Space>-R<Space>
let g:ctrlsf_ackprg = 'rg'

"indexer
let g:rndexer_ctagsCommandLineOptions="--c-kinds=+p+l+x+c+d+e+f+g+m+n+s+t+u+v --fields=+iaSl --extra=+q"
let g:indexer_dontUpdateTagsIfFileExists = 1

"fzf
nnoremap <silent> <Leader>f :Files<cr>
nnoremap <silent> <Leader>t :Tags<cr>
nnoremap <silent> <Leader>b :Buffers<cr>
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'

"easymotion
let g:EasyMotion_smartcase = 1
let g:EasyMotion_verbose = 0
let g:EasyMotion_do_mapping = 0
map <Leader> <Plug>(easymotion-prefix)
map <Leader>j <Plug>(easymotion-s)

"echodoc
let g:echodoc_enable_at_startup = 1
set noshowmode

"ycm
let g:ycm_semantic_triggers =  {
	\   'c' : [ '->' , '.' , 're!\w{2}' ],
	\   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s', 're!\[.*\]\s'],
	\   'ocaml' : ['.', '#'],
	\   'cpp,objcpp' : ['->', '.', '::'],
	\   'perl' : ['->'],
	\   'php' : ['->', '::'],
	\   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
	\   'ruby' : ['.', '::'],
	\   'lua' : ['.', ':'],
	\   'erlang' : [':'],
	\ }
let g:ycm_use_ultisnips_completer = 0
let g:ycm_disable_for_files_larger_than_kb = 0
let g:ycm_complete_in_comments=1
let g:ycm_confirm_extra_conf=0
let g:ycm_collect_identifiers_from_comments_and_strings=1
let g:ycm_collect_identifiers_from_tags_files=1
set completeopt-=preview
let g:ycm_min_num_of_chars_for_completion=2
let g:ycm_cache_omnifunc=0
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_show_diagnostics_ui = 0
let g:ycm_complete_in_strings = 1

"nerdcomment
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let NERDCompactSexyComs=1

set cc=81
set nu
set noswapfile
set background=dark
colorschem solarized
syntax enable
syntax on
set lazyredraw
set modelines=0
set report=0
set backspace=indent,eol,start
set showcmd
set hidden
set autoread
set shortmess+=I
set nojoinspaces
set timeout timeoutlen=300 ttimeoutlen=100
set nostartofline
set encoding=utf-8
set fileencoding=utf8
set fileencodings=utf-8
set incsearch
set hlsearch
set smartcase
set ignorecase
set wildmenu
set wildmode=list:longest
set listchars=tab:⋮\ ,trail:␣,eol:\ ,nbsp:▫		"backup: ⋮☇✓✗▫‚„¬𝄻𝄽
set ruler
set splitbelow
set splitright
set visualbell
set noerrorbells
set vb t_vb= 
filetype on 
filetype indent on
filetype plugin on
set cursorline
"hi MatchParen ctermbg=NONE
noremap m %
cnoremap <c-a> <Home>
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
nnoremap <silent> <backspace> :nohl<cr>
nnoremap lb ^
nnoremap le $
nnoremap lh 0
nnoremap lt g_
noremap Y y$
map <leader>v :e! ~/.vimrc<cr>
autocmd! bufwritepost .vimrc source %

" set *(#) in visual mode to forward/backward search selected content
vnoremap * y/<C-r>0<CR>
vnoremap # y?<C-r>0<CR>

noremap * *zz
noremap # #zz
noremap <c-o> <c-o>zz
noremap <c-i> <c-i>zz
"noremap n nzz
"noremap <s-n> <s-n>zz
"noremap j gjzz
"noremap k gkzz


cmap W w !sudo tee % >/dev/null
autocmd FileType python set tabstop=4 | set shiftwidth=4 | set softtabstop=4 | set expandtab | set autoindent
au FileType c,cpp  setl cindent cinoptions+=:0

"let g:solarized_termcolors = 256

"airline
let g:airline_theme = 'solarized'
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#branch#empty_message = 'no_git'
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = ''
