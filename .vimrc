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
Plugin 'editorconfig/editorconfig-vim'
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

" prevent editor config from loading for vim commit message
let g:EditorConfig_exclude_patterns = ['COMMIT_EDITMSG']

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
	call s:SqlQuery(a:server, a:db, sqlFile, tempname(), "new", 0)
endfunction

function! s:QueryDbDiff(serverA, dbA, serverB, dbB)
	let sqlFile = tempname()
	let lines = getline(1,'$')
	let test = writefile(lines, sqlFile)

	let a = tempname()
	let b = tempname()
	call s:SqlQuery(a:serverB, a:dbB, sqlFile, b, "new", 1)
	call s:SqlQuery(a:serverA, a:dbA, sqlFile, a, "vnew", 1)

	:redraw
endfunction

command! -nargs=+ QueryDb call s:QueryDb(<f-args>)
command! -nargs=+ QueryDbDiff call s:QueryDbDiff(<f-args>)

function s:RestoreRosnetDb(server, db)
	let lines = []
	call add(lines, "exec dbo.rsp_Create_Job_RestoreDevDBs '" . a:db . "';")
	call add(lines, "go")
	call add(lines, "exec sp_start_job 'RestoreDevDBs';")
	call add(lines, "go")
	let sqlFile = tempname()
	:echom sqlFile
	let test = writefile(lines, sqlFile)
	let new = "c:\\temp\\RestoreRosnetDbResult.txt"
	call s:SqlQuery(a:server, "msdb", sqlFile, new, "new", 0)
endfunction
command! -nargs=+ RestoreRosnetDb call s:RestoreRosnetDb(<f-args>)

function s:RestoreRosnetDbStatus(server)
	let lines = []
	call add(lines, "SELECT start_time, percent_complete, dateadd(second,estimated_completion_time/1000, getdate()) as estimate, substring(a.text, 0, 30) AS Query FROM sys.dm_exec_requests r CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) a WHERE r.command in ('BACKUP DATABASE','RESTORE DATABASE')")
	let sqlFile = tempname()
	:echom sqlFile
	let test = writefile(lines, sqlFile)
	let new = "c:\\temp\\RestoreRosnetDbStatus.txt"
	call s:SqlQuery(a:server, "msdb", sqlFile, new, "new", 0)
endfunction
command! -nargs=+ RestoreRosnetDbStatus call s:RestoreRosnetDbStatus(<f-args>)

function s:LockRosnetDb(server, db, lockedBy, note)
	let server = a:server
	if (a:server == "dev")
		let server = "ROSDEV15-KCI-DC"
	endif
	if (a:server == "qa")
		let server = "ROSDEV18-KCI-DC"
	endif
	let lines = []
	call add(lines, "insert into f_lock_db ( SQL_Server_ID, Database_Name, Locked_By, Notes) values ( '" . server . "', '" . a:db . "', '" . a:lockedBy . "', '" . a:note . "')")
	let sqlFile = tempname()
	:echom sqlFile
	let test = writefile(lines, sqlFile)
	let new = "c:\\temp\\LockRosnetDb.txt"
	call s:SqlQuery('ROSDEV16-KCI-DC', "zz_db_admin", sqlFile, new, "new", 0)
endfunction
command! -nargs=+ LockRosnetDb call s:LockRosnetDb(<f-args>)

function s:UnLockRosnetDb(server, db)
	let server = a:server
	if (a:server == "dev")
		let server = "ROSDEV15-KCI-DC"
	endif
	if (a:server == "qa")
		let server = "ROSDEV18-KCI-DC"
	endif
	let lines = []
	call add(lines, "delete f_lock_db where sql_server_id = '" . server . "' and database_name = '" . a:db . "'")
	let sqlFile = tempname()
	:echom sqlFile
	let test = writefile(lines, sqlFile)
	let new = "c:\\temp\\UnLockRosnetDb.txt"
	call s:SqlQuery('ROSDEV16-KCI-DC', "zz_db_admin", sqlFile, new, "new", 0)
endfunction
command! -nargs=+ UnLockRosnetDb call s:UnLockRosnetDb(<f-args>)

