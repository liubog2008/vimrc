set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include vim-plug and initialize
call plug#begin('~/.vim/bundle')

" let Vundle manage Vundle, required
Plug 'VundleVim/Vundle.vim'
Plug 'tpope/vim-obsession'
Plug 'fatih/vim-go'
Plug 'Valloric/YouCompleteMe'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdtree'
Plug 'fatih/molokai'
Plug 'Yggdroot/indentLine'
Plug 'mileszs/ack.vim'
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" for javascript and react
" Plug 'mephux/vim-jsfmt'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" for rust
Plug 'rust-lang/rust.vim'

Plug 'bkad/CamelCaseMotion'

" for GFM
Plug 'junegunn/vim-easy-align'
Plug 'mzlogin/vim-markdown-toc'

" trailing
Plug 'bronson/vim-trailing-whitespace'

" graphviz
Plug 'wannesm/wmgraphviz.vim'

" for lsp
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }


" All of your Plugins must be added before the following line
call plug#end()            " required

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

" for nvim
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

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
let NERDTreeShowHidden=1

" for color
colorscheme molokai
hi MatchParen ctermfg=208 ctermbg=none cterm=bold

" for indent
set list lcs=tab:\|\ 
let g:indentLine_char = '|'

" for vim-go
let g:go_fmt_command = "goimports"
let g:go_def_mode='gopls'
let g:go_auto_sameids = 1
let g:go_auto_type_info = 1
let g:go_def_mapping_enabled = 0
au FileType go nmap <silent> gi :GoImplements<CR>
au FileType go nmap <leader>gt :GoDeclsDir<CR>
au FileType go nmap <leader>gc :GoCoverageToggle -short<CR>
au FileType go nmap gd :GoDef<CR>


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
au FileType markdown vmap <tab> :EasyAlign*<Bar><Enter>
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" for html
autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab

" for js
autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
autocmd BufRead,BufNewFile,BufEnter .eslintrc setlocal ts=2 sts=2 sw=2 expandtab

" for jenkinsfile
autocmd BufRead,BufNewFile,BufEnter Jenkinsfile setlocal ts=4 sts=4 sw=4 expandtab

" for golang
" let g:syntastic_aggregate_errors = 1
" let g:syntastic_go_checkers = ['gometalinter']

" for neomake
" call neomake#configure#automake('nw', 1000)

" for ale
let g:ale_linters = {
            \ 'go': ['golangci-lint'],
            \ 'python': ['flake8', 'pylint'],
            \ 'rust': ['cargo', 'rls'],
            \ }

let g:ale_fixers = {
            \ 'python': ['autopep8', 'yapf', 'isort'],
            \ 'rust': ['rustfmt'],
            \ }

let g:ale_go_golangci_lint_package = 1
let g:ale_sign_column_always = 1

let g:ale_lint_on_enter = 0
let g:ale_fix_on_save = 1
let g:ale_echo_msg_format = '[%linter%] %s'
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" ycm
let g:ycm_python_binary_path = '/usr/local/bin/python3'
" nnoremap gd :YcmCompleter GoTo<CR>
" nnoremap gr :YcmCompleter GoToReferences<CR>

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 2
let airline#extensions#c_like_langs = ['c', 'cpp', 'cuda', 'go', 'javascript', 'ld', 'php']

" for json
set conceallevel=0

" for graphviz

" for neovim terminal
tnoremap <C-[> <C-\><C-n>

" for lsp
let g:LanguageClient_serverCommands = {
    \ 'rust': ['ra_lsp_server'],
    \ }

" for rust
au FileType rust nnoremap gd :call LanguageClient#textDocument_definition()<CR>

