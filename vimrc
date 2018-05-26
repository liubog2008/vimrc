set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-obsession'
Plugin 'fatih/vim-go'
Plugin 'Valloric/YouCompleteMe'
Plugin 'tpope/vim-surround'
Plugin 'jiangmiao/auto-pairs'
Plugin 'scrooloose/nerdtree'
Plugin 'fatih/molokai'
Plugin 'Yggdroot/indentLine'
Plugin 'mileszs/ack.vim'
Plugin 'w0rp/ale'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" for javascript
" Plugin 'mephux/vim-jsfmt'
Plugin 'pangloss/vim-javascript'

Plugin 'bkad/CamelCaseMotion'

" for GFM
Plugin 'junegunn/vim-easy-align'
Plugin 'mzlogin/vim-markdown-toc'

" trailing
Plugin 'bronson/vim-trailing-whitespace'


" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"   Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
"   Plugin 'L9'
" Git plugin not hosted on GitHub
"   Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"   Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"   Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
"   Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set number
syntax on
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" leader
let mapleader=";"

" for tmux
if !has('nvim') && exists('$TMUX')
    set term=screen-256color
endif

" for NERDTree
map <C-e> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" for color
colorscheme molokai
hi MatchParen ctermfg=208 ctermbg=none cterm=bold

" for indent
set list lcs=tab:\|\ 
let g:indentLine_char = '|'

" for vim-go
let g:go_fmt_command = "goimports"
let g:go_auto_sameids = 1
let g:go_auto_type_info = 1
au FileType go nmap <silent> gi :GoImplements<CR>
au FileType go nmap <leader>gt :GoDeclsDir<CR>
au FileType go nmap <leader>gc :GoCoverageToggle -short<CR>


" for window swap
function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf
endfunction
function! SwapWithRightWindow()
    call MarkWindowSwap()
    exe "wincmd l"
    call DoWindowSwap()
endfunction

nmap <silent> <leader>mw :call MarkWindowSwap()<CR>
nmap <silent> <leader>pw :call DoWindowSwap()<CR>
nmap <silent> <leader>slw :call SwapWithRightWindow()<CR>

" for js-fmt
let g:js_fmt_fail_silently = 0
let g:js_fmt_autosave = 1
let g:js_fmt_command = "jsfmt"


" for header
autocmd bufnewfile /go/src/github.com/caicloud/*.go so ~/.vim/header.txt

" for ag
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif
set shellpipe=>
cnoreabbrev ag Ack!
nnoremap <Leader>a :Ack!<Space>
"function Search(string) abort
"  let saved_shellpipe = &shellpipe
"  let &shellpipe = '>'
"  try
"    execute 'Ack!' shellescape(a:string, 1)
"  finally
"    let &shellpipe = saved_shellpipe
"  endtry
"endfunction
" command! -nargs=1 Ag call Search(<f-args>)

call camelcasemotion#CreateMotionMappings('<leader>')

" for yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" for markdown
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" for js
autocmd FileType js setlocal ts=2 sts=2 sw=2 expandtab

" for jenkinsfile
autocmd BufRead,BufNewFile,BufEnter Jenkinsfile setlocal ts=4 sts=4 sw=4 expandtab

" for golang
" let g:syntastic_aggregate_errors = 1
" let g:syntastic_go_checkers = ['gometalinter']

" for neomake
" call neomake#configure#automake('nw', 1000)

" for ale
let g:ale_linters = {
            \ 'go': ['gometalinter'],
            \ 'python': ['flake8', 'pylint'],
            \ }

let g:ale_fixers = {
            \ 'python': ['autopep8', 'yapf', 'isort'],
            \ }

let g:ale_sign_column_always = 1
let g:ale_lint_on_enter = 0
let g:ale_fix_on_save = 1
let g:ale_echo_msg_format = '[%linter%] %s'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" ycm
let g:ycm_python_binary_path = 'python'
nnoremap gd :YcmCompleter GoTo<CR>
nnoremap gr :YcmCompleter GoToReferences<CR>

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 2
let airline#extensions#c_like_langs = ['c', 'cpp', 'cuda', 'go', 'javascript', 'ld', 'php']

" for json
set conceallevel=0
