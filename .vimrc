set tabstop=4
set shiftwidth=4
set fenc=utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis
set autoindent
set smartindent
" Ctrl + v 階段状にしない
set pastetoggle=<C-E>
set number

if has('mac')
	set termencoding=utf-8
	set encoding=utf-8
	set fileencoding=utf-8
	set fileencodings=utf-8,cp932
endif

" 文字コードの自動認識
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif




"================================
"			key map
"================================
"	emacs keybind
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <Del>
inoremap <C-b> <Left>
inoremap <C-n> <Down>
inoremap <C-p> <Up>
inoremap <C-f> <Right>
"	Normal ModeのままEnterで改行挿入
noremap <CR> o<ESC>


"================================
"			One line move
"	eclipseの一行移動
"	Alt(Option) + <up><down>
"================================
function! s:move_block(d) range
	let cnt = a:lastline - a:firstline
	if a:d ==# 'u'
		let sign = '-'
		let cnt = 2
	else
		let sign = '+'
		let cnt += 1
	endif
	execute printf('%d,%dmove%s%d', a:firstline, a:lastline, sign, cnt)
endfunction

vnoremap <Down> :call <SID>move_block('d')<Cr>==gv
vnoremap <Up> :call <SID>move_block('u')<Cr>==gv




"================================
"         for auto run(js?)
"
"================================
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" add plugins
filetype plugin on

NeoBundleCheck

NeoBundle 'thinca/vim-quickrun'
NeoBundle 'Markdown'

let $JS_CMD='node'


"================================
" ruby php 自動実行
" Normal mode -> push 'space key'
" ===============================
function! ExecuteCurrentFile()
	if &filetype == 'php' || &filetype == 'ruby'
		execute '!' . &filetype . ' %'
	endif
endfunction
nnoremap <Space> :call ExecuteCurrentFile()<CR>

"================================
" python 自動実行
" push ' CTRL + p '
" ===============================

function! s:Exec()
    exe "!" . &ft . " %"        
:endfunction         
command! Exec call <SID>Exec() 
map <silent> <C-P> :call <SID>Exec()<CR>
