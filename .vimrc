set nocompatible

set ts=4
set sw=4

" turn on syntax folding (toggle folds with za)
let g:xml_syntax_folding=1
set foldmethod=syntax

" turn on code completion
filetype plugin on
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

set number
set nowrap

" ----------------------------------------------------
"                  tag stuff
" ----------------------------------------------------
"
" search for tags in current dir then parent and so on
set tags=./tags;/
" open taglist with T
nnoremap <silent> T :TlistToggle<CR>
" give the taglist focus when it's opened
let Tlist_GainFocus_On_ToggleOpen = 1


" ----------------------------------------------------
"                  package management 
" ----------------------------------------------------
" 
" stuff required to get vundle to work
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
filetype plugin indent on

" list of installed packages
Bundle 'gmarik/vundle'
Bundle 'vcscommand.vim'
Bundle 'surround.vim'
Bundle 'taglist.vim'
Bundle 'Zenburn'
Bundle 'TaskList.vim'
Bundle 'SuperTab-continued.'
Bundle 'xmledit'
Bundle 'xml.vim'


" ----------------------------------------------------
"                color scheme
" ----------------------------------------------------
"
" enable zenburn and make it look good in the terminal
colorscheme zenburn
set t_Co=256

" set font in gvim
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_win32")
    set guifont=Consolas:h10:cANSI
  endif
endif

" add command to format xml
if executable("xmllint")
	function! DoFormatXml()
		% !xmllint.exe % --format
	endfunction
	command FormatXml call DoFormatXml()
endif


