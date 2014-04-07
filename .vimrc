
"#######################
" encording
"#######################
set fenc=utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis

"-------------------mac----------------------
if has('mac')
	set termencoding=utf-8
	set encoding=utf-8
	set fileencoding=utf-8
	set fileencodings=utf-8,cp932
endif

"------------文字コードの自動認識-----------
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif

"#######################
" 表示系
"#######################
set number "行番号表示
set showmode "モード表示
set title "編集中のファイル名を表示
set ruler "ルーラーの表示
set showcmd "入力中のコマンドをステータスに表示する
set showmatch "括弧入力時の対応する括弧を表示
set laststatus=2 "ステータスラインを常に表示
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
" コメントアウトをインデントしない
"inoremap # X^H# 

" コピペする時に階段状にインデントさせない
imap <F11> <nop>
set pastetoggle=<F11>

"CTRL+L OR :redraw で画面再描画

"#######################
" プログラミング系
"#######################
syntax on "カラー表示
set smartindent "オートインデント
" tab関連
"set expandtab "タブの代わりに空白文字挿入
"set ts=4 sw=4 sts=0 "タブは半角4文字分のスペース
" ファイルを開いた際に、前回終了時の行で起動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

"#######################
" 検索系
"#######################
set ignorecase "検索文字列が小文字の場合は大文字小文字を区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る
set noincsearch "検索文字列入力時に順次対象文字列にヒットさせない
set nohlsearch "検索結果文字列の非ハイライト表示

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


"*********************Plug in***************************
"================================
"        NeoBundle 
"================================
"----------environment-----------
if has('win32') || has('win64')
	set shellslash
	let $VIMDIR = expand('~/vimfiles')
else
	let $VIMDIR = expand('~/.vim')
endif
"-----------Settings------------
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

"----------add plugins----------
filetype plugin on
NeoBundleCheck

NeoBundle 'thinca/vim-quickrun'
NeoBundle 'Markdown'
" ファイル操作
NeoBundle 'Shougo/unite.vim'
" 補完
NeoBundle 'Shougo/neocomplcache'
" snippet
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
" smart inputのruby対応版
NeoBundle "kana/vim-smartinput"
NeoBundle "cohama/vim-smartinput-endwise"
call smartinput_endwise#define_default_rules()
" ruby 自動def end補完 -- endwise
NeoBundle "tpope/vim-endwise"

"================================
"		    plug-in settings
" 			neocomplcache
" 			vim 補完
"================================
"" neocomplcache
NeoBundle 'Shougo/neocomplcache'
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : ''
		\ }

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
	return neocomplcache#smart_close_popup() . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
"inoremap <expr><C-e>  neocomplcache#cancel_popup()
