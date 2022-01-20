set nocompatible
set encoding=utf-8
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
set nobackup
set directory=~/.vim/swap

" turn on syntax folding (toggle folds with za)
let g:xml_syntax_folding=1
set foldmethod=syntax
set foldlevelstart=3
syntax on;

" turn on code completion
filetype plugin on
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" disable syntax for large files to prevent slowdown
autocmd BufReadPre * if getfsize(expand("%")) > 10000000 | syntax off | endif

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
Plugin 'VundleVim/Vundle.vim'

" list of installed packages
Plugin 'thinca/vim-fontzoom'
Plugin 'gmarik/vundle'
Plugin 'vcscommand.vim'
Plugin 'surround.vim'
Plugin 'tpope/vim-repeat'
Plugin 'visSum.vim'
"Plugin 'taglist.vim'
Plugin 'will133/vim-dirdiff'
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
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
Plugin 'scrooloose/nerdtree'
Plugin 'chrisbra/csv.vim'
Plugin 'sbdchd/neoformat'

" js / react stuff
Plugin 'pangloss/vim-javascript'
Plugin 'MaxMEllon/vim-jsx-pretty'

" colorschemes
Plugin 'flazz/vim-colorschemes'
Plugin 'Heorhiy/VisualStudioDark.vim'
Plugin 'felixhummel/setcolors.vim'
Plugin 'ajmwagar/vim-deus'
Plugin 'neomake/neomake'

call vundle#end()
filetype plugin indent on

" neomake config
let g:neomake_open_list = 2
call neomake#configure#automake('nw', 750)


" ----------------------------------------------------
"                color scheme
" ----------------------------------------------------
"
" set font for neovim qt
set guifont=Consolas:h10
if has("gui_running")
  " set font in gvim
  " gui colors
  " favorites: zenburn anderson deus wombat VisualStudioDark gruvbox
  " pencil
  colorscheme pencil
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_win32")
    set guifont=Consolas:h10:cANSI
  endif
else
  " terminal colors
  colorscheme 0x7A69_dark
endif


" add command to format xml
" if on windows run choco install xsltproc to get xmllint
if executable("xmllint")
	function! DoFormatXml()
		% !xmllint.exe % --format
	endfunction
	command FormatXml call DoFormatXml()
endif

if executable("python")
	function! DoFormatJson()
		:%!python -m json.tool
	endfunction
	command FormatJson call DoFormatJson()
endif

if executable("sqlformat")
	function! DoFormatSql()
		:%!sqlformat --indent "  " -U
		set syntax=sql
	endfunction
	command FormatSql call DoFormatSql()
endif

" configure nerdtree
map <A-;> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen = 1

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
	set ts=4
	set lines=75 columns=121
	colorscheme jellybeans
endfunction
 " au BufNewFile,BufRead COMMIT_EDITMSG call GitCommitSettings()

" prevent editor config from loading for vim commit message
let g:EditorConfig_exclude_patterns = ['COMMIT_EDITMSG']

" settings for editing trello card text
function! TrelloSettings()
	set tw=58
	set syntax=markdown
endfunction
au BufNewFile,BufRead vimperator-trello.* call TrelloSettings()

function! s:SqlQueryDart(env, client, loc, busDate, sqlFile, outFile, bufOpenCmd)
	set syntax=sql
	let cmd = "RosTools QueryDataSets -eod -e " . a:env . " -c " . a:client . " -l " . a:loc . " -b \"" . a:busDate . "\" -i \"" . a:sqlFile . "\" -o " . a:outFile
	silent execute "!" . cmd
	if (bufnr(a:outFile) < 0)
		execute a:bufOpenCmd a:outFile
		:setl autoread
	endif
endfunction

function! s:SqlQueryRos(env, db, sqlFile, outFile, bufOpenCmd, diff)
	set syntax=sql
	let cmd = "RosTools query --timeout 120 -e " . a:env . " -db " . a:db . " -i \"" . a:sqlFile . "\" -o " . a:outFile
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
	set syntax=sql
	let cmd = "RosTools query --timeout 120 -s " . a:server . " -db " . a:db . " -i \"" . a:sqlFile . "\" -o " . a:outFile
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

function! s:QueryDart(env, client, loc, busDate)
	let sqlFile = tempname()
	let lines = getline(1,'$')
	let test = writefile(lines, sqlFile)
	call s:SqlQueryDart(a:env, a:client, a:loc, a:busDate, sqlFile, tempname(), "new")
endfunction

command! -nargs=+ Query call s:Query(<f-args>)
command! -nargs=+ QueryDiff call s:QueryDiff(<f-args>)
command! -nargs=+ QueryRos call s:QueryRos(<f-args>)
command! -nargs=+ QueryRosDiff call s:QueryRosDiff(<f-args>)
command! -nargs=+ QueryDart call s:QueryDart(<f-args>)

