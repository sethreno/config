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
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" list of installed packages
Plugin 'gmarik/vundle'
Plugin 'vcscommand.vim'
Plugin 'surround.vim'
"Plugin 'taglist.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'TaskList.vim'
Plugin 'SuperTab-continued.'
Plugin 'xmledit'
Plugin 'xml.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'dbext.vim'
Plugin 'vim-scripts/OutlookVim'
Plugin 'highlight.vim'
Plugin 'vim-scripts/CycleColor'

call vundle#end()
filetype plugin indent on


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
set guioptions+=c

" settings for git commit messages
function! GitCommitSettings()
	setlocal spell	
	set lines=75 columns=120
	colorscheme xoria256   " red & green diff
	%s///g               " remove ^M added by git diff
	syntax sync fromstart  " refresh syntax highlight after replace
	1                      " move to line 1
endfunction
au BufNewFile,BufRead COMMIT_EDITMSG call GitCommitSettings()

" settings for editing trello card text
function! TrelloSettings()
	set tw=58
	set syntax=markdown
endfunction
au BufNewFile,BufRead vimperator-trello.* call TrelloSettings()

function! s:SqlQuery(server, db, sqlFile, outFile, bufOpenCmd, diff)
	let cmd = "sqlcmd -S " . a:server . " -d " . a:db . " -i \"" . a:sqlFile . "\" -o " . a:outFile
	silent execute "!" . cmd
	if (bufnr(a:outFile) < 0)
		execute a:bufOpenCmd a:outFile
		if (a:diff == 1)
			:diffthis
		endif
		:setl autoread
	endif
endfunction

function! s:QueryDb(server, db)
	let sqlFile = tempname()
	let lines = getline(1,'$')
	let test = writefile(lines, sqlFile)
	call s:SqlQuery(a:server, a:db, sqlFile, "c:\\temp\QueryDb.txt", "new", 0)
endfunction

function! s:ParityQuery(server, db)
	let sqlFile = tempname()
	let lines = getline(1,'$')
	let test = writefile(lines, sqlFile)

	let new = "c:\\temp\\ParityQuery_new.txt"
	let old = "c:\\temp\\ParityQuery_old.txt"
	let newDb = a:server . "\\instance2"
	let oldDb = a:server
	if (a:server == "localhost")
		let oldDb = a:server . "\\sqlexpress"
	endif
	call s:SqlQuery(newDb, a:db, sqlFile, new, "new", 1)
	call s:SqlQuery(oldDb, a:db, sqlFile, old, "vnew", 1)

	:redraw
endfunction

command! -nargs=+ ParityQuery call s:ParityQuery(<f-args>)
command! -nargs=+ QueryDb call s:QueryDb(<f-args>)

