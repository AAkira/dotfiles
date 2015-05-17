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
" file format
"#######################
"================================
" .mdがmarkdownではなくmodula2として認識されるので…
"================================
augroup PrevimSettings
autocmd!
autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END

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
set suffixesadd+=.rb "gfコマンド ファイル検索の拡張子

"#######################
" その他
"#######################
set backspace=indent,eol,start "空白文字, 前の行の改行, 文字以外も削除可
set whichwrap=b,s,<,>,[,]	"左右のカーソル移動で行間移動可能

"#######################
"			key map
"#######################
"	emacs keybind
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <Del>
inoremap <C-b> <Left>
inoremap <C-n> <Down>
inoremap <C-p> <Up>
inoremap <C-f> <Right>
inoremap <C-k> <C-o>D
"	Normal ModeのままEnterで改行挿入
noremap <CR> o<ESC>
" 文の途中でも次の行に改行して移動
inoremap <C-j> <ESC>o
" 1行->2行表示でもj,kで移動
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk
" コピペずれないようにtoggle
set pastetoggle=<C-z>
" 自動挿入
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>

" ************* plugin *************
" NERDTree plugin
nnoremap <silent><C-e> :NERDTreeToggle<CR>
" neocomplete plugin
inoremap <expr><CR>   pumvisible() ? neocomplete#close_popup() : "<CR>"
inoremap <expr><C-e>  pumvisible() ? neocomplete#close_popup() : "<End>"
inoremap <expr><C-f>  pumvisible() ? neocomplete#close_popup()."<Right>" : "<Right>"
inoremap <expr><C-b>  pumvisible() ? neocomplete#close_popup() : "<Left>"
inoremap <expr><C-c>  neocomplete#cancel_popup()
inoremap <expr><C-u>  neocomplete#undo_completion()
inoremap <expr><C-s>  neocomplete#start_manual_complete()

"================================
" [Space] script 実行
"===============================
function! ExecuteCurrentFile()
	if &filetype == 'php' || &filetype == 'ruby' || &filetype == 'python' || &filetype == 'perl' || &filetype == 'sh'
		execute '!' . &filetype . ' %'
	elseif &filetype == 'vim'
		execute 'source %'
	elseif &filetype == 'javascript'
		execute '!node %'
	endif
endfunction
nnoremap <Space> :call ExecuteCurrentFile()<CR>


"================================
" 挿入モード時に色を変える
"===============================
if !exists('g:hi_insert')
	let g:hi_insert = 'highlight StatusLine guifg=White guibg=DarkCyan gui=none ctermfg=White ctermbg=DarkCyan cterm=none'
endif

if has('unix') && !has('gui_running')
	inoremap <silent> <ESC> <ESC>
	inoremap <silent> <C-[> <ESC>
endif

if has('syntax')
	augroup InsertHook
	autocmd!
	autocmd InsertEnter * call s:StatusLine('Enter')
	autocmd InsertLeave * call s:StatusLine('Leave')
	augroup END
endif

let s:slhlcmd = ''

function! s:StatusLine(mode)
	if a:mode == 'Enter'
		silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
		silent exec g:hi_insert
	else
		highlight clear StatusLine
		silent exec s:slhlcmd
	endif
endfunction

function! s:GetHighlight(hi)
	redir => hl
	exec 'highlight '.a:hi
	redir END
	let hl = substitute(hl, '[\r\n]', '', 'g')
	let hl = substitute(hl, 'xxx', '', '')
	return hl
endfunction

"================================
" 全角スペースをハイライト
"===============================
function! ZenkakuSpace()
	highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
	augroup ZenkakuSpace
	autocmd!
	autocmd ColorScheme       * call ZenkakuSpace()
	autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
	augroup END
	call ZenkakuSpace()
endif

"*********************Plug in***************************
"================================
"       NeoBundle 
"		----install command---
"		:so $MYVIMRC | NeoBundleInstall
"================================
"----------environment-----------
if has('win32') || has('win64')
	set shellslash
	let $VIMDIR = expand('~/vimfiles')
else
	let $VIMDIR = expand('~/.vim')
endif

"-----------Settings------------
set runtimepath+=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle/'))
 
NeoBundleFetch 'Shougo/neobundle.vim'
  
" ----plugins start---
" NERDTree
NeoBundle 'scrooloose/nerdtree'
" ファイル操作
NeoBundle 'Shougo/unite.vim'
" 補完
function! s:neobundle_enable()
	return has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
endfunction

if s:neobundle_enable()
	NeoBundle 'Shougo/neocomplete'
else
	NeoBundle 'Shougo/neocomplcache'
endif
" snippet
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'

" open browser
NeoBundle 'tyru/open-browser.vim'
" previm vimで書いたmarkdownをpreview
NeoBundle 'kannokanno/previm'

" HTML auto reload
NeoBundle 'tell-k/vim-browsereload-mac'

" HTML coding emmet
NeoBundle 'mattn/emmet-vim'

" Surround vim
NeoBundle 'tpope/vim-surround'

" js補完
" buildに失敗したら
" ~/.vim/bundle/tern_for_vimでnpm installする
NeoBundle 'marijnh/tern_for_vim', {
			\ 'build': {
			\   'others': 'sudo npm install',
			\  },
			\}

" ----plugins end---
   
call neobundle#end()

filetype plugin indent on
" 未インストールのプラグインがある場合インストールするかどうかを毎回尋ねる
NeoBundleCheck
"================================
"       NeoBundle end
"================================


"================================
"		    plug-in settings
" 			previm
" 			commands 
"================================
" browserで開く
" open-browser.vimを使用する場合は不要
" let g:previm_open_cmd = 'open -a Google\ Chrome'

" Markdown Preview
" <F7>でプレビュー
nnoremap <silent> <F7> :PrevimOpen<CR>

"================================
"		    plug-in settings
"		    quick starter
"================================
" リロード後に戻ってくるアプリ
let g:returnApp = "Terminal"
nmap <C-Y>bc :ChromeReloadStart<CR>
nmap <C-Y>bC :ChromeReloadStop<CR>
nmap <C-Y>bf :FirefoxReloadStart<CR>
nmap <C-Y>bF :FirefoxReloadStop<CR>
nmap <C-Y>bs :SafariReloadStart<CR>
nmap <C-Y>bS :SafariReloadStop<CR>
nmap <C-Y>bo :OperaReloadStart<CR>
nmap <C-Y>bO :OperaReloadStop<CR>
nmap <C-Y>ba :AllBrowserReloadStart<CR>
nmap <C-Y>bA :AllBrowserReloadStop<CR>

"================================
"		    plug-in settings
"		    Emmet 
"================================
let g:user_emmet_mode = 'iv'
let g:user_emmet_leader_key = '<C-Y>'
let g:use_emmet_complete_tag = 1
let g:user_emmet_settings = { 
			\ 'variables': { 
			\ 'lang' : 'ja' 
			\ } 
			\} 
augroup EmmitVim
	autocmd!
	autocmd FileType * let g:user_emmet_settings.indentation = '               '[:&tabstop]
augroup END

"================================
"		    plug-in settings
"		    Neocomplete
"		    [reference]
"		    https://github.com/Shougo/neocomplete.vim/blob/master/doc/neocomplete.txt
"================================
if neobundle#is_installed('neocomplete')
	" neocomplete用設定
	" auto start 
	let g:neocomplete#enable_at_startup = 1

	if !exists('g:neocomplete#keyword_patterns')
		let g:neocomplete#keyword_patterns = {}
	endif
	let g:neocomplete#keyword_patterns._ = '\h\w*'
	" あいまいok
	let g:neocomplete#enable_fuzzy_completion = 1
	" 大文字小文字
	let g:neocomplete#enable_ignore_case              = 1
	let g:neocomplete#enable_smart_case               = 1
	let g:neocomplete#enable_camel_case               = 1
	" 最初の候補選ばない
	let g:neocomplete#enable_auto_select							= 0

	call neocomplete#custom_source('_', 'sorters',  ['sorter_length'])
	call neocomplete#custom_source('_', 'matchers', ['matcher_head'])
	" Enable omni completion.
	autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
	autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
	autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
	autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
	autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
	" js normal
	""autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
	" use tern_for_vim : js completion plugin 
	" autocmd FileType javascript setlocal omnifunc=tern#Complete
	" autocmd FileType typescript setlocal omnifunc=tern#Complete

	" snippet ColorScheme(Terminal using ctermbg)
	highlight Pmenu ctermbg=180 guibg=#e0dcc0
	highlight PmenuSel ctermbg=172 guifg=#938f70 guibg=#938f70
	highlight PmenuSbar ctermbg=138 guibg=#938F70
elseif neobundle#is_installed('neocomplcache')
    " neocomplcache用設定
    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_enable_ignore_case = 1
    let g:neocomplcache_enable_smart_case = 1
    if !exists('g:neocomplcache_keyword_patterns')
        let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns._ = '\h\w*'
    let g:neocomplcache_enable_camel_case_completion = 1
    let g:neocomplcache_enable_underbar_completion = 1
endif
