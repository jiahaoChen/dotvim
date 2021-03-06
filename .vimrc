" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

filetype on
filetype indent on
filetype plugin on

syntax on

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set laststatus=2        " Always show the statusline
set nu
set bs=2
set history=1000
set ruler
set autoread
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set autoindent
set copyindent
set ignorecase
set smartcase
set smarttab
set hlsearch            " search highlighting
set clipboard+=unnamed
set formatoptions=tcrqn
set mouse=nv

autocmd! bufwritepost .vimrc source ~/.vimrc

"if has("gui_running")
   "colorscheme oceandeep
   colorscheme molokai
   "colorscheme wombat256mod
   "colorscheme asmanian_blood
   "colorscheme desert
   "colorscheme gentooish
   set linespace=3
   set t_Co=256 	" 256 color mode
   set cursorline 	" hightlight current line
"endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
map <silent> <F2> :NERDTreeToggle<CR>
map <silent> <F3> :TlistToggle<CR>

" TAB setting {
  set expandtab 	"replace <TAB> with spaces
  set softtabstop=4
  set shiftwidth=4
  au FileType Makefile set noexpandtab
"}
"
"Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" set leader to ,
let mapleader=","
let g:mapleader=","

" --- superTab
let g:SuperTabDefaultCompletionType="context"
let g:SuperTabCompletionContexts=['s:ContextText', 's:ContextDiscover']

" --- Command-T
let g:CommandTMaxHeight=15

" --- AutoClose
"if !has("gui_running")
"   set term=linux
   imap OA <ESC>ki
   imap OB <ESC>ji
   imap OC <ESC>li
   imap OD <ESC>hi

   nmap OA k
   nmap OB j
   nmap OC l
   nmap OD h
"endif

" ---ctags
set tags=~/.vim/tags
set tags+=tags

" ---cscope
if has("cscope")
    set cscopequickfix=s-,c-,d-,i-,t-,e-
    set csto=0
    set cst
    set csverb
endif

" --- clang_complete
"let g:clang_snippets=1
"let g:clang_snippets_engine='snipmate'
let g:clean_complete_auto = 0
let g:clang_complete_copen = 1
let g:clang_use_library = 1
let g:clang_libary_path = "/usr/lib"
set completeopt=menu,longest

" ENCODING SETTING
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,big5,gb2312,latin1

" QUICKFIX WINDOW
command -bang -nargs=? QFix call QFixToggle(<bang>0)

function! QFixToggle(forced)
if exists("g:qfix_win") && a:forced == 0
cclose
unlet g:qfix_win
else
copen 10
let g:qfix_win = bufnr("$")
endif
endfunction

map <silent> <F4> :QFix <CR>
map <silent> <F5> :make <CR>
map <silent> <F7> :Grep <CR>
map <silent> <F8> :call Do_CsTag()<CR>

function Do_CsTag()
    let dir = getcwd()
    if filereadable("tags")
        let tagsdeleted=delete("./"."tags")
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif
    
    if has("cscope")
        silent! execute "cs kill -1"
    endif
    
    if filereadable("cscope.files")
        let csfilesdeleted=delete("./"."cscope.files")
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif
    
    if filereadable("cscope.out")
        let csoutdeleted=delete("./"."cscope.out")
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif

    if(executable('ctags'))
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif

    if(executable('cscope') && has("cscope"))
        silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' > cscope.files"
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction

