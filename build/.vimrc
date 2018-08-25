set number

" make tabs 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab

set ruler

colorscheme delek
"colorscheme darkblue

" When vimrc is edited, reload it
autocmd! bufwritepost vimrc source ~/.vimrc

set wildmenu    " Turn on WiLd menu
set ruler		" Alwyas show current position

set cmdheight=2 "The commandbar height

set magic "Set magic on for regular expressions
set showmatch " show matching bracets when text indicator is over them

syntax enable "Enable syntax h1 

" change color of auto complete menu
highlight Pmenu ctermfg=white ctermbg=blue
highlight PmenuSel ctermfg=white ctermbg=red

" change color of search highlight
hi Search cterm=underline,bold ctermfg=white ctermbg=27
hi IncSearch cterm=underline,bold ctermfg=white ctermbg=88

"au BufRead,BufNewFile *.cl set filetype=c
au BufRead,BufNewFile *.cl set filetype=opencl
au BufRead,BufNewFile *.cu set filetype=c

"set nohlsearch "Disable highlighting when searching

set gfn=Menlo:h14
set shell=/bin/bash

set ai "Auto indent
set si "Smart indent

" Airline setup
set laststatus=2
let g:airline_theme='dark'

" when splitting, put it below
set splitbelow

" split navigations
" Ctrl-J Move to split below
nnoremap <C-J> <C-W><C-J>
" Ctrl-K Move to split above 
nnoremap <C-K> <C-W><C-K>
" Ctrl-L Move to split right 
nnoremap <C-L> <C-W><C-L>
" Ctrl-H Move to split left 
nnoremap <C-H> <C-W><C-H>

" Enable folding
"set foldmethod=syntax
"set foldlevel=99

" Enable folding (za) with spacebar
nnoremap <space> za

":nnoremap <C-A> m'<C-A>vUgUTx''
":nnoremap <C-A> <C-A>vUgUTx

" Fill column to 80 chars with spaces and inset character
function! Fillup( str )
    " Set the fill chat to space
    let char = " "
    " set tw to the desired totoal length
    let tw = &textwidth
    if tw==0 | let tw = 80 | endif
    " strip trailing spaces first
    .s/[[:space:]]*$//
    " Calculate total number of spaces to insert
    let reps = (tw - col("$")) - len(a:str)
    " insert spaces
    if reps > 0
        .s/$/\=(' '.repeat(char, reps))/
    endif
    .s/$/\=(a:str)/
endfunction

function! ExpandCMacro()
  "get current info
  let l:macro_file_name = "__macroexpand__" . tabpagenr()
  let l:file_row = line(".")
  let l:file_name = expand("%")
  let l:file_window = winnr()
  "create mark
  execute "normal! Oint " . l:macro_file_name . ";"
  execute "w"
  "open tiny window ... check if we have already an open buffer for macro
  if bufwinnr( l:macro_file_name ) != -1
    execute bufwinnr( l:macro_file_name) . "wincmd w"
    setlocal modifiable
    execute "normal! ggdG"
  else
    execute "bot 10split " . l:macro_file_name
    execute "setlocal filetype=cpp"
    execute "setlocal buftype=nofile"
    nnoremap <buffer> q :q!<CR>
  endif
  "read file with gcc
  silent! execute "r!gcc -E " . l:file_name
  "keep specific macro line
  execute "normal! ggV/int " . l:macro_file_name . ";$\<CR>d"
  execute "normal! jdG"
  "indent
  execute "%!indent -st -kr"
  execute "normal! gg=G"
  "resize window
  execute "normal! G"
  let l:macro_end_row = line(".")
  execute "resize " . l:macro_end_row
  execute "normal! gg"
  "no modifiable
  setlocal nomodifiable
  "return to origin place
  execute l:file_window . "wincmd w"
  execute l:file_row
  execute "normal!u"
  execute "w"
  "highlight origin line
  let @/ = getline('.')
endfunction

autocmd FileType cpp nnoremap <leader>m :call ExpandCMacro()<CR>

noremap <f2> :call ExpandCMacro()<return>
inoremap <f2> <c-o>:call ExpandCMacro()<return>

noremap <f3> :noh<return>

" Allow saving of files as sudo when I forget to start vim using sudo
cmap w!! w !sudo tee > /dev/null %

" Show tabs as >---
set list
set listchars=tab:>·,trail:·

"set listchars=tab:>-,trail:·
"set listchars=tab:!·,trail:·
