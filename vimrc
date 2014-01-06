" General "{{{
set nocompatible  " disable vi compatibility.
set history=256  " Number of things to remember in history.
set autowrite  " Writes on make/shell commands
set autoread
set timeoutlen=250  " Time to wait after ESC (default causes an annoying delay)
set clipboard+=unnamed  " Yanks go on clipboard instead.
set tags=./tags;$HOME " walk directory tree upto $HOME looking for tags
" Modeline
set modeline
set modelines=5 " default numbers of lines to read for modeline instructions
" Backup
set nowritebackup
set nobackup
set directory=/tmp// " prepend(^=) $HOME/.tmp/ to default path; use full path as backup filename(//)
" Buffers
set hidden " The current buffer can be put to the background without writing to disk
" Match and search
set hlsearch
" 搜索时忽略大小写
set ignorecase
" 随着键入即时搜索
set incsearch
" 有一个或以上大写字母时仍大小写敏感
set smartcase 
" "}}}

autocmd! bufwritepost .vimrc source %

" Formatting "{{{
set fo+=o " Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
set fo-=r " Do not automatically insert a comment leader after an enter
set fo-=t " Do no auto-wrap text using textwidth (does not apply to comments)

set nowrap
set textwidth=0    " Don't wrap lines by default
set wildmode=longest,list " At command line, complete longest common string, then list alternatives.

set backspace=indent,eol,start  " more powerful backspacing

set tabstop=4    " Set the default tabstop
set softtabstop=4
set shiftwidth=4 " Set the default shift width for indents
set expandtab   " Make tabs into spaces (set by tabstop)
set smarttab " Smarter tab levels
set autoindent

syntax on               " enable syntax
filetype plugin indent on             " Automatically detect file types.
" "}}}

" Visual "{{{
set number  " Line numbers off
set showmatch  " Show matching brackets.
set matchtime=5  " Bracket blinking.
set novisualbell  " No blinking
set noerrorbells  " No noise.
set laststatus=2  " Always show status line.
set vb t_vb= " disable any beeps or flashes on error
set ruler  " Show ruler
set showcmd " Display an incomplete command in the lower right corner of the Vim window
set shortmess=atI " Shortens messages

set listchars=tab:·\ ,trail:·,extends:»,precedes:« " Unprintable chars mapping
set list

set foldenable " Turn on folding
set foldmethod=marker " Fold on the marker
set foldlevel=100 " Don't autofold anything (but I can still fold manually)
set foldopen=block,hor,mark,percent,quickfix,tag " what movements open folds

set mouse-=a   " Disable mouse
set mousehide  " Hide mouse after chars typed

set splitbelow
set splitright
set complete+=k

" "}}}

" Command and Auto commands " {{{
" Sudo write
comm! W exec 'w !sudo tee % > /dev/null' | e!

"Auto commands
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

au FileType python setl sw=4 sts=4 et
au BufRead,BufNewFile {*.tac}     set ft=python
au FileType c,cpp,java,php,python autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal g'\"" | endif " restore position in file
autocmd BufWritePost *.py call Flake8()
" }}}

" Key mappings " {{{
nnoremap <silent> <LocalLeader>rs :source ~/.vimrc<CR>
nnoremap <silent> <LocalLeader>rt :tabnew ~/.vim/vimrc<CR>
nnoremap <silent> <LocalLeader>re :e ~/.vim/vimrc<CR>
nnoremap <silent> <LocalLeader>rd :e ~/.vim/ <CR>

" Tabs
nnoremap <silent> <LocalLeader>[ :tabprev<CR>
nnoremap <silent> <LocalLeader>] :tabnext<CR>
" Duplication
vnoremap <silent> <LocalLeader>= yP
nnoremap <silent> <LocalLeader>= YP
" Buffers
nnoremap <silent> <LocalLeader>- :bd<CR>
" Split line(opposite to S-J joining line)
nnoremap <silent> <C-J> gEa<CR><ESC>ew

" map <silent> <C-W>v :vnew<CR>
" map <silent> <C-W>s :snew<CR>

nnoremap # :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
nnoremap * #

map <S-CR> A<CR><ESC>
"
" Control+S and Control+Q are flow-control characters: disable them in your terminal settings.
" $ stty -ixon -ixoff
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

set runtimepath+=~/.vim/bundle/vundle/

" Plugins " {{{
call vundle#rc()

Bundle "YankRing.vim"

" Programming
Bundle "nvie/vim-flake8"
let g:flake8_max_line_length=99

Bundle "davidhalter/jedi-vim"
Bundle "https://github.com/simon-liu/snipMate"
Bundle "rails.vim"
Bundle "https://github.com/tmhedberg/SimpylFold"

" Session Manager
Bundle "sessionman.vim"

" Utility
Bundle "uarun/vim-protobuf"
" {{{
au BufNewFile,BufRead *.proto set ft=proto
"}}}

Bundle "rodjek/vim-puppet"
Bundle "repeat.vim"
Bundle "surround.vim"
Bundle "bling/vim-airline"
Bundle "phpfolding.vim"
Bundle "hughbien/md-vim"
Bundle "terryma/vim-multiple-cursors"
" {{{
au BufNewFile,BufRead *.md set ft=md
"}}}

Bundle "flazz/vim-colorschemes"
colorscheme af

" FuzzyFinder
Bundle "L9"
Bundle "FuzzyFinder"
map ,, :FufCoverageFile <CR>
let g:fuf_modesDisable = []
let g:fuf_coveragefile_globPatterns = ['**/*.h', '**/*.c', '**/*.cc', '**/*.rb', '**/*.erb', '**/*.php', '**/*.py', '**/*.html', '**/*.sh', '**/*.pp']
" {{{
nnoremap <silent> <LocalLeader>h :FufHelp<CR>
nnoremap <silent> <LocalLeader>2  :FufFileWithCurrentBufferDir<CR>
nnoremap <silent> <LocalLeader>@  :FufFile<CR>
nnoremap <silent> <LocalLeader>3  :FufBuffer<CR>
nnoremap <silent> <LocalLeader>4  :FufDirWithCurrentBufferDir<CR>
nnoremap <silent> <LocalLeader>$  :FufDir<CR>
nnoremap <silent> <LocalLeader>5  :FufChangeList<CR>
nnoremap <silent> <LocalLeader>6  :FufMruFile<CR>
nnoremap <silent> <LocalLeader>7  :FufLine<CR>
nnoremap <silent> <LocalLeader>8  :FufBookmark<CR>
nnoremap <silent> <LocalLeader>*  :FuzzyFinderAddBookmark<CR><CR>
nnoremap <silent> <LocalLeader>9  :FufTaggedFile<CR>
" " }}}

" tComment
Bundle "tComment"
nnoremap // :TComment<CR>
vnoremap // :TComment<CR>

"自动补全单引号，双引号等 Bundle 'underlog/ClosePairs'
Bundle 'Raimondi/delimitMate'

" Navigation
Bundle "https://github.com/gmarik/vim-visual-star-search.git"
Bundle "bufexplorer.zip"
" " }}}
