set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-git'

"Plugin 'git://git.code.sf.net/p/vim-latex/vim-latex'

"Plugin 'ap/vim-templates'
"Plugin 'drbeco/vimtemplates'
Plugin 'aperezdc/vim-template'
Plugin 'adimit/prolog.vim'
"Plugin 'tmhedberg/SimpylFold'
"Plugin 'vim-scripts/indentpython.vim'
Plugin 'lervag/vimtex'
"Plugin 'Shougo/neocomplete.vim'
"Plugin 'fatih/vim-go'
"Plugin 'jceb/vim-orgmode'
Plugin 'chrisbra/csv.vim'
" Colors
Plugin 'exitface/synthwave.vim'
Plugin 'ayu-theme/ayu-vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'Glench/Vim-Jinja2-Syntax'
"Plugin 'maksimr/vim-jsbeautify'
Plugin 'rhysd/committia.vim'
"Plugin 'tell-k/vim-autopep8'
"Plugin 'w0rp/ale'
"Plugin 'zxqfl/tabnine-vim'

Plugin 'NLKNguyen/papercolor-theme'
Plugin 'scrooloose/nerdtree'

Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rhubarb'
Plugin 'shumphrey/fugitive-gitlab.vim'

Plugin 'google/vim-maktaba'
Plugin 'google/vim-codefmt'
Plugin 'google/vim-glaive'

Plugin 'iamcco/markdown-preview.nvim'

Plugin 'vhdirk/vim-cmake'

Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'


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
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
" vim-template options
let g:user        = "Till Hofmann"
let g:email       = "hofmann@kbsg.rwth-aachen.de"
let g:dateformat  = "%c"

" vimtex
"let g:vimtex_view_method = 'mupdf'
"let g:vimtex_view_general_viewer = 'qpdfview'
" add mappings
call vimtex#imaps#add_map({
  \ 'lhs' : 'v',
  \ 'rhs' : '\vec'
  \})
call vimtex#imaps#add_map({
  \ 'lhs' : 'i',
  \ 'rhs' : '\item ',
  \ 'wrapper' : 'vimtex#imaps#wrap_environment',
  \ 'context' : ["itemize", "enumerate"],
  \})
call vimtex#imaps#add_map({
  \ 'lhs': '9',
  \ 'rhs': '\left('
  \})
call vimtex#imaps#add_map({
  \ 'lhs': '0',
  \ 'rhs': '\right)'
  \})
call vimtex#imaps#add_map({
  \ 'lhs': '(',
  \ 'rhs': '\mleft('
  \})
call vimtex#imaps#add_map({
  \ 'lhs': ')',
  \ 'rhs': '\mright)'
  \})
let g:vimtex_fold_enabled=0
"let g:vimtex_latexmk_callback=0

" vimtex + neocomplete
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.tex =
      \ '\v\\%('
      \ . '\a*cite\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|\a*ref%(\s*\{[^}]*|range\s*\{[^,}]*%(}\{)?)'
      \ . '|hyperref\s*\[[^]]*'
      \ . '|includegraphics\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|%(include%(only)?|input)\s*\{[^}]*'
      \ . '|\a*(gls|Gls|GLS)(pl)?\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|includepdf%(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . '|includestandalone%(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . ')'

" vimtex + YouCompleteMe
if !exists('g:ycm_semantic_triggers')
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = g:vimtex#re#youcompleteme

" rust with YouCompleteMe
let g:ycm_rust_src_path = '/usr/lib/rustlib/src/rust/src/'

" YouCompleteMe + clangd settings
let g:ycm_clangd_uses_ycmd_caching = 0
"let g:ycm_clangd_binary_path = exepath("clangd")

" autopep
let g:autopep8_cmd = 'autopep8-3'
let g:autopep8_disable_show_diff = 1
let g:autopep8_on_save = 1

let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

set tabstop=2
set sw=2
"set textwidth=80
"set colorcolumn=81
highlight ColorColumn ctermbg=7
set et
set iskeyword+=:
set winaltkeys=no
set autochdir
"set <m-i>=i
syntax on
set background=dark

set wildmode=longest,list,full
set wildmenu

autocmd FileType cmake,cpp nnoremap <C-m> :make!<CR>
autocmd FileType cmake,cpp nnoremap <C-t> :make! CTEST_OUTPUT_ON_FAILURE=1 all test<CR>
autocmd FileType cmake,cpp nnoremap <leader>b :CMake<CR>

" cmake
let g:cmake_export_compile_commands = 1
let g:cmake_ycm_symlinks = 1
"let g:cmake_build_flags = "-j`nproc`"
let g:cmake_use_smp = 1
let g:cmake_build_type = "Debug"

" Set prolog as default filetype for .pl files
au BufRead,BufNewFile *.pl set filetype=prolog

"set termguicolors     " enable true colors support
"let ayucolor="light"  " for light version of theme
"let ayucolor="mirage" " for mirage version of theme
"let ayucolor="dark"   " for dark version of theme
colorscheme ayu

" YCM setttings
nnoremap <leader>g :YcmCompleter GoTo<CR>
nnoremap <leader>r :YcmCompleter GotoReferences<CR>
nnoremap <leader>f :YcmCompleter FixIt<CR>
nnoremap <leader>e :lnext<CR>
nnoremap <leader>E :lprevious<CR>

" committia
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
    " Additional settings
    setlocal spell

    " If no commit message, start with insert mode
    if a:info.vcs ==# 'git' && getline(1) ==# ''
        startinsert
    endif

    " Scroll the diff window from insert mode
    " Map <C-n> and <C-p>
    imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
    imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
endfunction

" color scheme PaperColor
set background=light
colorscheme PaperColor

" fugitive
let g:fugitive_gitlab_domains = ['https://git.rwth-aachen.de']

function! OneSentencePerLineFormatExpr(start, end)
  "let l:pos = getcurpos(".")
  silent execute a:start.','.a:end.'s/[.!?]\zs /\r/g'
  "call setpos(".", l:pos)
  :norm $
endfunction

"function! FormatOnSave()
"  let l:formatdiff = 1
"  py3f /usr/share/clang/clang-format.py
"endfunction
"autocmd BufWritePre *.h,*.cc,*.cpp call FormatOnSave()

call glaive#Install()
Glaive codefmt plugin[mappings]

augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  "autocmd FileType css,sass,scss,less,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
  autocmd FileType rust AutoFormatBuffer rustfmt
  "autocmd FileType vue AutoFormatBuffer prettier
augroup END

set modelineexpr

"autocmd FileType tex set formatexpr=OneSentencePerLineFormatExpr(v:lnum,v:lnum+v:count-1)
autocmd FileType tex set colorcolumn=0
autocmd FileType tex set textwidth=0

autocmd FileType spec set textwidth=0
autocmd FileType spec set colorcolumn=0
autocmd FileType csv set colorcolumn=0
autocmd FileType csv set textwidth=0
autocmd FileType jinja set colorcolumn=0
autocmd FileType jinja set textwidth=0
autocmd FileType clips set noexpandtab

set listchars=tab:→\ ,space:·,trail:·,precedes:←,extends:→
autocmd FileType make set list

map <C-K> :py3f /usr/share/clang/clang-format.py<cr>
imap <C-K> <c-o>:py3f /usr/share/clang/clang-format.py<cr>


map <C-n> :NERDTreeToggle<CR>

" ultisnips
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-l>"
let g:UltiSnipsJumpBackwardTrigger="<c-h>"

" markdown
call mkdp#util#install()

"autocmd FileType tex let b:ycm_largefile=1
