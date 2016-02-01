set nocompatible
filetype off


if has('python')
py << EOF
import os.path
import sys	
import vim
if 'VIRTUAL_ENV' in os.environ:
	project_base_dir = os.environ['VIRTUAL_ENV']
	sys.path.insert(0,os.path.join(project_base_dir,'lib','python3.4','site-packages'))
EOF
endif

"python << EOF
"print(sys.path)
"EOF

execute pathogen#infect()

if has("syntax")
    syntax on 
    endif
set modifiable

set number

set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set cindent

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"let Vundle manage Vundle
"required!

Bundle 'gmarik/vundle'
Bundle 'bling/vim-airline'
Bundle 'Lokaltog/powerline',{'rtp': 'powerline/bindings/vim/'}
Bundle 'scrooloose/nerdtree'
Bundle 'powerline/fonts'
Bundle 'flazz/vim-colorschemes'
Bundle 'kien/ctrlp.vim'
Bundle 'davidhalter/jedi-vim'
"Bundle 'python-rope/ropevim'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/neosnippet'
Bundle 'kevinw/pyflakes-vim'
Bundle 'jiangmiao/auto-pairs'
Bundle 'Yggdroot/indentLine'
Bundle 'tpope/vim-fugitive'
"The bundles you install will be listed here

filetype plugin indent on

"The rest of your config follows here

augroup vimrc_autocmds
    autocmd!
    " highlight characters past column 120
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python set nowrap
augroup END

"Powerline setup

set laststatus=2
let g:Powerline_powerline_fonts=1


if isdirectory(expand("~/.vim/bundle/vim-airline/"))
	if !exists('g:airline_theme')
		let g:airline_theme = 'solarized'
	endif
	if !exists('g:airline_powerline_fonts')
	" Use the default set of separators with a few customizations
		let g:airline_left_sep='›'  " Slightly fancier than '>'
		let g:airline_right_sep='‹' " Slightly fancier than '<'
	endif
endif

set guifont=DejaVu\ Sans:s12

let g:Powerline_symbols = 'fancy'

execute pathogen#infect()

"jedi setting

let g:jedi#usages_command = "<leader>z"
let g:jedi#documentation_command = "<leader>k"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedigoto_definitions_command =""
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#completions_command="<C-Space>"
let g:jedi#auto_close_doc = 1

"Python-repo setting

"let ropevim_extended_complete = 1
"let ropevim_enable_autoimport = 1
"let g:ropevim_autoimport_modules=["os.*","traceback","django.*"]
"imap <s-space> <C-R>=RopeCodeAssistInsertMode()<CR>


map <Leader>b Oimport ipdb; ipdb.set_trace() #BREAKPOINT<C-c>

set completeopt=longest,menuone
function! OmniPopup(action)
	if pumvisible()
		if a:action == 'j'
			return "\<C-N>"
		elseif a:action == 'k'
			return "\<C-P>"
		endif
	endif
	return a:action
endfunction

inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>	

"neocoimplcache setting
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_mart_case = 1
let g:neocomplcache_lock_buffer_name_pattern = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\'

"<TAB>:completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

"Enable omni completion
autocm FileType python setlocal omnifunc=pythoncomplete#Complete


let g:indentLine_color_term = 239
let g:indentLine_enabled = 1

map <F2> :NERDTreeToggle<CR>

map <F4> :call AddAuther()<CR>

function AddAuther()
	let n = 1
	while n < 11
		let line = getline(n)
		if line=~'[#]*\s*\*\s*\S*Last\s*modified\s*:\s*\S*.*$'
			call UpdateTitle()
			return 
		endif
		let n = n+1
	endwhile
	if &filetype == 'sh'
		call AddTitleForShell()
	elseif &filetype == 'python'
		call AddTitleForPython()
	elseif &filetype == 'cpp'
		call AddTitleForC()
	else
	endif
endfunction

function UpdateTitle()
	normal m'
	execute '/* Last modified\s*:/s@:.*$@\=strftime(": %Y-%m-%d %H:%M")@'
	normal mk
	execute '/* Filename\s*:/s@:.*$@\=": ".expand("%:t")@'
	execute "noh"
	normal 'k
	echohl WarningMsg | echo "Successful in updating the copy right." |echohl None
endfunction

function AddTitleForC()
	 call append(0,"/**********************************************************")
     call append(1," * Author        : ZhuYuRun")
	 call append(2," * Email         : zhuyurun2007@126.com")
	 call append(3," * Create time   : ".strftime("%Y-%m-%d %H:%M"))
	 call append(4," * Last modified : ".strftime("%Y-%m-%d %H:%M"))
	 call append(5," * Filename      : ".expand("%:t"))
	 call append(6," * Description   : ")
	 call append(7," * *******************************************************/")

	 echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
endfunction

function AddTitleForPython()
	call append(0,"#!/usr/bin/python")
	call append(1,"# -*- coding: UTF-8 -*-")
	call append(2,"")	
	call append(3,"# **********************************************************")
	call append(4,"# * Author        : ZhuYuRun")
	call append(5,"# * Email         : zhuyurun2007@126.com")
	call append(6,"# * Create time   : ".strftime("%Y-%m-%d %H:%M"))
	call append(7,"# * Last modified : ".strftime("%Y-%m-%d %H:%M"))
	call append(8,"# * Filename      : ".expand("%:t"))
	call append(9,"# * Description   : ")
	call append(10,"# **********************************************************")
	echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
endfunction

function AddTitleForShell()
	call append(0,"#!/bin/bash")
	call append(1,"# **********************************************************")
	call append(2,"# * Author        : ZhuYuRun")
	call append(3,"# * Email         : zhuyurun2007@126.com")
	call append(4,"# * Create time   : ".strftime("%Y-%m-%d %H:%M"))
	call append(5,"# * Last modified : ".strftime("%Y-%m-%d %H:%M"))
	call append(6,"# * Filename      : ".expand("%:t"))
	call append(7,"# * Description   : ")
	call append(8,"# **********************************************************")
endfunction
