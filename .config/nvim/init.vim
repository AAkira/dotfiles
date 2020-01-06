"#######################
" Encording
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
" File format
"#######################
"================================
" .mdがmarkdownではなくmodula2として認識されるので…
"================================
augroup PrevimSettings
autocmd!
autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END

"#######################
" Display
"#######################
set number "行番号表示
set showmode "モード表示
set title "編集中のファイル名を表示
set ruler "ルーラーの表示
set showcmd "入力中のコマンドをステータスに表示する
set showmatch "括弧入力時の対応する括弧を表示
set laststatus=2 "ステータスラインを常に表示
set expandtab "tab -> space
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent

"#######################
" Programing
"#######################
syntax on "カラー表示
set smartindent "オートインデント
" tab関連
"set expandtab "タブの代わりに空白文字挿入
"set ts=4 sw=4 sts=0 "タブは半角4文字分のスペース
" ファイルを開いた際に、前回終了時の行で起動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

"#######################
" Search
"#######################
set ignorecase "検索文字列が小文字の場合は大文字小文字を区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る
set noincsearch "検索文字列入力時に順次対象文字列にヒットさせない
set nohlsearch "検索結果文字列の非ハイライト表示
set suffixesadd+=.rb "gfコマンド ファイル検索の拡張子

"#######################
" substitution
"#######################
set inccommand=split "Show diff preview

"#######################
" Others
"#######################
set backspace=indent,eol,start "空白文字, 前の行の改行, 文字以外も削除可
set whichwrap=b,s,<,>,[,]       "左右のカーソル移動で行間移動可能
" file type detect
filetype detect

"#######################
" Keymap
"#######################
" emacs keybind - insert mode
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <Del>
inoremap <C-b> <Left>
inoremap <C-n> <Down>
inoremap <C-p> <Up>
inoremap <C-f> <Right>
inoremap <C-k> <C-o>D
" emacs keybind - command mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-b> <Left>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
cnoremap <C-f> <Right>
" Normal ModeのままEnterで改行挿入
noremap <CR> o<ESC>
" 文の途中でも次の行に改行して移動
inoremap <C-j> <ESC>o
" 1行->2行表示でもj,kで移動
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk
" ignore function keys
noremap! <F1> <nop>
noremap! <F2> <nop>
noremap! <F3> <nop>
noremap! <F4> <nop>
noremap! <F5> <nop>
noremap! <F6> <nop>
noremap! <F7> <nop>
noremap! <F8> <nop>
noremap! <F9> <nop>
noremap! <F10> <nop>
noremap! <F11> <nop>
noremap! <F12> <nop>
noremap! <F13> <nop>
" コピペずれないようにtoggle
set pastetoggle=<C-z>
" 自動挿入
"inoremap { {}<LEFT>
"inoremap [ []<LEFT>
"inoremap ( ()<LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>
"inoremap ` ``<LEFT>
" mac clipboard copy
vnoremap <silent><C-r> :!pbcopy;pbpaste<CR>
" mac clipboard cut
vnoremap <silent><C-x> :!pbcopy<CR>
" mac clipboard paste
nnoremap <silent><C-@> :r !pbpaste<CR>

"================================
" plugin keymap
"================================
" Written in ~/.vim/rc/dein.toml

"================================
" [Space] script 実行
"================================
function! ExecuteCurrentFile()
        if &filetype == 'php' || &filetype == 'ruby' || &filetype == 'python' || &filetype == 'perl' || &filetype == 'sh'
                execute '!' . &filetype . ' %'
        elseif &filetype == 'vim'
                execute 'source %'
        elseif &filetype == 'javascript'
                execute '!node %'
        elseif &filetype == 'typescript'
                execute '!ts-node %'
        elseif &filetype == 'go'
                execute '!go run %'
        endif
endfunction
nnoremap <Space> :call ExecuteCurrentFile()<CR>

"================================
" 挿入モード時に色を変える
"================================
if !exists('g:hi_insert')
        let g:hi_insert = 'highlight StatusLine guifg=White guibg=DarkCyan gui=none ctermfg=White ctermbg=DarkCyan cterm=none'
endif

if has('unix') && !has('gui_running')
        inoremap <silent> <ESC> <ESC>
        inoremap <silent> <C-[> <ESC>
        inoremap <silent> <C-]> <ESC>
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
"================================
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

"================================
" normal mode時に半角に切り替え only mac
"================================
if has('mac')
  set ttimeoutlen=1
  let g:imeoff = 'osascript -e "tell application \"System Events\" to key code 102"'
  augroup MyIMEGroup
    autocmd!
    autocmd InsertLeave * :call system(g:imeoff)
  augroup END
  noremap <silent> <ESC> <ESC>:call system(g:imeoff)<CR>
endif

"================================
" dein vim settings
"================================

"dein Scripts-----------------------------

if &compatible
  set nocompatible               " Be iMproved
endif

let s:dein_dir = expand('~/.cache/dein') " dein directory
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" Required:
execute 'set runtimepath^=' . s:dein_repo_dir

" Required:
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " Let dein manage dein
  " Required:
  call dein#add(s:dein_repo_dir)

  " Load plugins from toml file
  " Add or remove your plugins here:
"  call dein#add('Shougo/neosnippet.vim')
"  call dein#add('Shougo/neosnippet-snippets')

  " You can specify revision/branch/tag.
"  call dein#add('Shougo/deol.nvim', { 'rev': '01203d4c9' })

  " Plugin files
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " Cache TOML files
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

