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
set visualbell " don't beep - our clicky keyboard is annoying enough for the neighbors

" don't polute the world with temp files
set backup
set backupdir=~/.vim/backupdir
set backupskip=~/.vim/backupdir\*
set directory=~/.vim/swap
set writebackup

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
Plugin 'xmledit'
Plugin 'xml.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'dbext.vim'
Plugin 'vim-scripts/OutlookVim'
Plugin 'highlight.vim'
Plugin 'vim-scripts/CycleColor'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'easymotion/vim-easymotion'

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

	" uncomment the following lines if you have core.autocrlf false
	" alternatively run git config --global core.autocrlf true
	%s///g               " remove ^M added by git diff
	syntax sync fromstart  " refresh syntax highlight after replace
	1                      " move to line 1
endfunction
au BufNewFile,BufRead COMMIT_EDITMSG call GitCommitSettings()

" prevent editor config from loading for vim commit message
let g:EditorConfig_exclude_patterns = ['COMMIT_EDITMSG']

" settings for editing trello card text
function! TrelloSettings()
	set tw=58
	set syntax=markdown
endfunction
au BufNewFile,BufRead vimperator-trello.* call TrelloSettings()

function! s:SqlQueryRos(env, db, sqlFile, outFile, bufOpenCmd, diff)
	let cmd = "RosTools query -e " . a:env . " -db " . a:db . " -i \"" . a:sqlFile . "\" -o " . a:outFile
	silent execute "!" . cmd
	if (bufnr(a:outFile) < 0)
		execute a:bufOpenCmd a:outFile
		if (a:diff == 1)
			:diffthis
		endif
		:setl autoread
	endif
endfunction

function! s:SqlQuery(server, db, sqlFile, outFile, bufOpenCmd, diff)
	let cmd = "RosTools query -s " . a:server . " -db " . a:db . " -i \"" . a:sqlFile . "\" -o " . a:outFile
	silent execute "!" . cmd
	if (bufnr(a:outFile) < 0)
		execute a:bufOpenCmd a:outFile
		if (a:diff == 1)
			:diffthis
		endif
		:setl autoread
	endif
endfunction

function! s:Query(server, db)
	let sqlFile = tempname()
	let lines = getline(1,'$')
	let test = writefile(lines, sqlFile)
	call s:SqlQuery(a:server, a:db, sqlFile, tempname(), "new", 0)
endfunction

function! s:QueryDiff(serverA, dbA, serverB, dbB)
	let sqlFile = tempname()
	let lines = getline(1,'$')
	let test = writefile(lines, sqlFile)

	let a = tempname()
	let b = tempname()
	call s:SqlQuery(a:serverB, a:dbB, sqlFile, b, "new", 1)
	call s:SqlQuery(a:serverA, a:dbA, sqlFile, a, "vnew", 1)

	:redraw
endfunction

function! s:QueryRos(env, db)
	let sqlFile = tempname()
	let lines = getline(1,'$')
	let test = writefile(lines, sqlFile)
	call s:SqlQueryRos(a:env, a:db, sqlFile, tempname(), "new", 0)
endfunction

function! s:QueryRosDiff(envA, dbA, envB, dbB)
	let sqlFile = tempname()
	let lines = getline(1,'$')
	let test = writefile(lines, sqlFile)

	let a = tempname()
	let b = tempname()
	call s:SqlQueryRos(a:envB, a:dbB, sqlFile, b, "new", 1)
	call s:SqlQueryRos(a:envA, a:dbA, sqlFile, a, "vnew", 1)

	:redraw
endfunction

command! -nargs=+ Query call s:Query(<f-args>)
command! -nargs=+ QueryDiff call s:QueryDiff(<f-args>)
command! -nargs=+ QueryRos call s:QueryRos(<f-args>)
command! -nargs=+ QueryRosDiff call s:QueryRosDiff(<f-args>)

