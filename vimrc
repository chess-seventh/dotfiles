set nocompatible              " be iMproved, required
syntax on
filetype plugin indent on

call plug#begin('~/.vim/plugged')
" VIM Pretty
"
"
Plug 'scrooloose/nerdtree'
Plug 'chrisbra/colorizer'
"
" VIM PLUGINS
"
Plug 'towolf/vim-helm'
Plug 'bronson/vim-trailing-whitespace'
Plug 'gorodinskiy/vim-coloresque'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mattn/gist-vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'godlygeek/tabular'
Plug 'flazz/vim-colorschemes'

" PERSONAL WIKI
Plug 'vimwiki/vimwiki'


"
"SNIPETS
"
Plug 'tmhedberg/SimpylFold'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'scrooloose/nerdcommenter'
"
" Track the engine.
Plug 'git@github.com:SirVer/ultisnips.git'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

"
" GIT
"
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'rhysd/git-messenger.vim'
Plug 'chemzqm/vim-easygit'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
"
" Terraform Plugin
"

Plug 'hashivim/vim-terraform'
Plug 'vim-syntastic/syntastic'
Plug 'juliosueiras/vim-terraform-completion'

"
" PYTHON
"
Plug 'vim-scripts/indentpython.vim'
Plug 'nvie/vim-flake8'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'davidhalter/jedi-vim'

"
" CODE COMPLETION & SYNTAX
"
Plug 'ekalinin/Dockerfile.vim'
Plug 'Valloric/YouCompleteMe', { 'do': 'python install.py' }
Plug 'dense-analysis/ale'


call plug#end()

set encoding=utf8

if has('python3')
endif

" ===========================
" ===========================
" COLORS / DESIGN
" ===========================
" ===========================
" set background = dark
" colorscheme slate
colorscheme badwolf
" colorscheme elflord
" colorscheme darkblue
"
set tabstop=2
set expandtab
set number
set cursorline
set laststatus=2
"
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
"
"set clipboard+=unnamedplus
set clipboard=unnamedplus
"
let g:airline_powerline_fonts=1
let g:airline_theme='term'
" let g:airline_theme='alduin'
"
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
"
let g:airline#extensions#tabline#enabled = 1
"
" AIRLINE symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
"
" prettify the files and folders.
let s:brown = "905532"
let s:aqua =  "3AFFDB"
let s:blue = "689FB6"
let s:darkBlue = "44788E"
let s:purple = "834F79"
let s:lightPurple = "834F79"
let s:red = "AE403F"
let s:beige = "F5C06F"
let s:yellow = "F09F17"
let s:orange = "D4843E"
let s:darkOrange = "F16529"
let s:pink = "CB6F6F"
let s:salmon = "EE6E73"
let s:green = "8FAA54"
let s:lightGreen = "31B53E"
let s:white = "FFFFFF"
let s:rspec_red = 'FE405F'
let s:git_orange = 'F54D27'


" ===========================
" ===========================
" AUTOCOMPLETION Keybinds
" ===========================
" ===========================
" YouCompleteMe
let g:ale_completion_enabled = 1

" let g:UltiSnipsExpandTrigger="<c-o>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"
" TERRAFORM Adds
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" (Optional)Remove Info(Preview) window
"set completeopt-=preview

" (Optional)Hide Info(Preview) window after completions
" autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
" autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" (Optional) Enable terraform plan to be include in filter
let g:syntastic_terraform_tffilter_plan = 1

" (Optional) Default: 0, enable(1)/disable(0) plugin's keymapping
let g:terraform_completion_keys = 0

" (Optional) Default: 1, enable(1)/disable(0) terraform module registry completion
let g:terraform_registry_module_completion = 0

" ==========
" Ultisnips
" ==========
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsExpandTrigger="<c-o>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir        = $HOME.'/.vim/UltiSnips/'
let g:UltiSnipsSnippetDirectories=["UltiSnips"]
let g:UltiSnipsListSnippets="<c-h>"


"
" SYNTAX CHECKERS
" let g:syntastic_python_checkers = ['pylint', 'python']
let g:syntastic_python_checkers = ['virutalenv']
let g:syntastic_c_checkers = ['clang_check', 'clang_tidy', 'gcc', 'make', 'cppcheck']
let g:syntastic_css_checkers = ['csslint', 'prettycss']
let g:syntastic_dockerfile_checkers = ['dockerfile_lint']
let g:syntastic_haskell_checkers = ['hdevtools', 'hlint', 'scan']
let g:syntastic_html_checkers = ['eslint', 'gjslint', 'tidy']
let g:syntastic_java_checkers = ['checkstyle', 'javac']
let g:syntastic_javascript_checkers = ['flow', 'eslint', 'jsl']
let g:syntastic_json_checkers = ['jsonlint']
let g:syntastic_mardown_checkers = ['mdl']
let g:syntastic_matlab_checkers = ['mlint']
let g:syntastic_ruby_checkers = ['flog']
let g:syntastic_scala_checkers = ['fsc', 'scalac']
let g:syntastic_sh_checkers = ['bashate', 'sh', 'shellcheck']
let g:syntastic_sql_checkers = ['sqlint']
let g:syntastic_tex_checkers = ['chktex', 'lacheck']
let g:syntastic_zsh_checkers = ['zsh']
"

" ===========================
" ===========================
" NAVIGATION
" ===========================
" ===========================
" move between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
"
" Code folding (Enable)
set foldmethod=indent
set foldlevel=99
nnoremap <space> za
let g:SimpylFold_docstring_preview=1

"""""""""""""""""""""""""""""""""""""""""""""
""
"" FZF
""
"""""""""""""""""""""""""""""""""""""""""""""
" Mapping selecting mappings

" Insert mode completion
" imap <c-x><c-k> <plug>(fzf-complete-word)
" imap <c-x><c-f> <plug>(fzf-complete-path)
" imap <c-x><c-j> <plug>(fzf-complete-file-ag)
" imap <c-x><c-l> <plug>(fzf-complete-line)

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10new' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=161 ctermbg=251
  highlight fzf2 ctermfg=23 ctermbg=251
  highlight fzf3 ctermfg=237 ctermbg=251
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()


" ===========================
" ===========================
" PYTHON
" ===========================
" ===========================
let g:pymode_python = 'python3'
let g:pymode_rope = 0
"
" pretty python code
let python_highlight_all=1
"
" pep8 indendation
au BufNewFile,BufRead *.py
\ set tabstop=4 |
\ set softtabstop=4 |
\ set shiftwidth=4 |
\ set expandtab |
\ set autoindent |
\ set fileformat=unix |
"
"
" for modules in same directory.
let g:ale_python_pylint_options = "--init-hook='import sys; sys.path.append(\".\")'"
"
" VIRTUALENV
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  exec(open(activate_this).read(), dict(__file__=activate_this))
EOF
"
" pretty python
let python_highlight_all=1
let g:syntastic_mode_map = { 'passive_filetypes': ['python'] }

" ===========================
" ===========================
" NERDTREE
" ===========================
" ===========================
">> auto open if no file selected
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" ignore files in NERDTree
let NERDTreeIgnore=['\.pyc$', '\~$']
" autoclose when opening a file
let NERDTreeQuitOnOpen = 0
let g:NERDTreeDisableFileExtensionHighlight = 1
let g:NERDTreeDisableExactMatchHighlight = 1
let g:NERDTreeDisablePatternMatchHighlight = 1
let g:NERDTreeExtensionHighlightColor = {} " this line is needed to avoid error
let g:NERDTreeExtensionHighlightColor['css'] = s:blue " sets the color of css files to blue
let g:NERDTreeExactMatchHighlightColor = {} " this line is needed to avoid error
let g:NERDTreeExactMatchHighlightColor['.gitignore'] = s:git_orange " sets the color for .gitignore files
let g:NERDTreePatternMatchHighlightColor = {} " this line is needed to avoid error
let g:NERDTreePatternMatchHighlightColor['.*_spec\.rb$'] = s:rspec_red " sets the color for files ending with _spec.rb

" ===========================
" ===========================
" MY COMMANDS
" ===========================
" ===========================
" Vim Markdown preview command remapping
let mapleader = ","
nmap <leader>ne :NERDTree<CR>
nmap <leader>bn :n<CR>
nmap <leader>bp :p<CR>
nmap <leader>= :vertical resize +5<CR>
nmap <leader>- :vertical resize -5<CR>
nmap <leader>st :SyntasticToggleMode<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>f :Files<CR>
nmap <leader>T :Tags<CR>
nmap <leader>t :BTags<CR>
nmap <leader>s :Ag<CR>
" nnoremap <leader>s :ToggleWorkspace<CR>
nmap <leader>s :ToggleWorkspace<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>ga :Gadd<CR>
nmap <leader>gc :Gcommit<CR>
nmap <leader>gst :Gstatus<CR>

nmap <F9> :TagbarToggle<CR>

"
" CTAGS
"
function CreateTags()
    let curNodePath = g:NERDTreeFileNode.GetSelected().path.str()
    exec ':!ctags -R --languages=python -f ' . curNodePath . '/tags ' . curNodePath
endfunction

nmap <leader>ct :call CreateTags()<CR>
"
" SESSIONS !
let g:workspace_create_new_tabs = 0  " enabled = 1 (default), disabled = 0
let g:workspace_session_directory = $HOME . '/.vim/sessions/'
let g:workspace_session_name = 'session.vim'
let g:workspace_autosave_always = 1
let g:workspace_autosave_ignore = ['gitcommit']


" resize pane
if bufwinnr(1)
  map + <C-W>+
  map - <C-W>-
endif

"""
" NOTMUCH ADDRESS BOOK
"""

autocmd BufWritePre * :%s/\s\+$//e
"Git add - remove commands...
let g:easygit_enable_command = 1
"
"

