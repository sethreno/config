set nocompatible

set ts=4
set sw=4
set ruler
set laststatus=2 "always show status
set number
set nowrap
set tw=72
set autoindent
set backspace=eol,start,indent
set clipboard=unnamed "copy and paste to system clipboard

" turn off temp files
set nobackup
set nowritebackup
set noswapfile

" turn on syntax folding (toggle folds with za)
let g:xml_syntax_folding=1
set foldmethod=syntax
syntax on;

" turn on code completion
filetype plugin on
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

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
Bundle 'flazz/vim-colorschemes'
Bundle 'TaskList.vim'
Bundle 'SuperTab-continued.'
Bundle 'xmledit'
Bundle 'xml.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'dbext.vim'
Bundle 'vim-scripts/OutlookVim'
Bundle 'highlight.vim'
Bundle 'vim-scripts/CycleColor'



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

" configure dbext
let g:dbext_default_SQLSRV_bin = 'sqlcmd'
let g:dbext_default_SQLSRV_cmd_options  = ''

" hide unused stuff in gvim
set guioptions-=m
set guioptions-=T
set guioptions-=r

" settings for git commit messages
function GitCommitSettings()
	setlocal spell	
	set lines=75 columns=120
	colorscheme xoria256   " red & green diff
	%s///g               " remove ^M added by git diff
	syntax sync fromstart  " refresh syntax highlight after replace
	1                      " move to line 1
endfunction
au BufNewFile,BufRead COMMIT_EDITMSG call GitCommitSettings()

" settings for editing trello card text
function TrelloSettings()
	set tw=58
	set syntax=markdown
endfunction
au BufNewFile,BufRead vimperator-trello.* call TrelloSettings()

