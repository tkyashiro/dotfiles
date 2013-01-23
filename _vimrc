"Last Change:2013/01/23 14:24:11.

"*****************************************************************
" Plugin Install - Vundle
"*****************************************************************
set nocompatible
filetype off
if has("win32") || has("win64")
	set rtp+=$VIM/vimfiles/vundle.git/
	call vundle#rc('~/vimfiles/bundle/')
else
	set rtp+=~/.vim/vundle.git/
	call vundle#rc()
endif

" Github 上のリポジトリから取得する場合 ↓の様に、Github のユーザ名とリポジトリ名を指定します。
" Bundle 'user_name/repository_name'

" vim-scripts 上のリポジトリから取得する場合 ↓の様に、plugin の名前を指定します。
" Bundle 'script_name'
Bundle 'FuzzyFinder'
Bundle 'minibufexpl.vim'
Bundle 'DoxygenToolkit.vim'
Bundle 'tagexplorer.vim'
Bundle 'AutoComplPop'
Bundle 'code-snippet'
Bundle 'Align'
Bundle 'clones/vim-l9'
Bundle 'syngan/vim-pukiwiki'
Bundle 'Shougo/neocomplcache'
Bundle 'glidenote/memolist.vim'
Bundle 'tpope/vim-markdown'

" それ以外の git リポジトリから取得する場合
" Bundle 'git://repository_url'

filetype plugin indent on     " required!

"*****************************************************************
" Function
"*****************************************************************
"---------------------------------
" ずんwiki (Encoding)
"---------------------------------
if &encoding !=# 'utf-8'
       set encoding=japan
endif
set fileencoding=japan
if has('iconv')
       let s:enc_euc = 'euc-jp'
       let s:enc_jis = 'iso-2022-jp'
       " iconvがJISX0213に対応しているかをチェック
       if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
               let s:enc_euc = 'euc-jisx0213'
               let s:enc_jis = 'iso-2022-jp-3'
       endif
       " fileencodingsを構築
       if &encoding ==# 'utf-8'
               let s:fileencodings_default = &fileencodings
               let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
               let &fileencodings = &fileencodings .','. s:fileencodings_default
               unlet s:fileencodings_default
       else
               let &fileencodings = &fileencodings .','. s:enc_jis
               set fileencodings+=utf-8,ucs-2le,ucs-2
               if &encoding =~# '^euc-\%(jp\|jisx0213\)$'
                       set fileencodings+=cp932
                       set fileencodings-=euc-jp
                       set fileencodings-=euc-jisx0213
                       let &encoding = s:enc_euc
               else
                       let &fileencodings = &fileencodings .','. s:enc_euc
               endif
       endif
       unlet s:enc_euc
       unlet s:enc_jis
endif

"---------------------------------
" 文字コードを最終行に追加
" thanks to http://hatena.g.hatena.ne.jp/hatenatech/20060515/1147682761
"---------------------------------
function! GetB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return String2Hex(c)
endfunction

" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  return r
endfunc

" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
  let out = ''
  let ix = 0
  while ix < strlen(a:str)
    let out = out . Nr2Hex(char2nr(a:str[ix]))
    let ix = ix + 1
  endwhile
  return out
endfunc

"*****************************************************************
" C++コマンド
"*****************************************************************
"let g:inserttag="HOGE" して、コメントを変更する
function InsertComment()
	let s:space = " "
	let s:ccomment = "//"
	let s:signature = "TY@"
	if( !exists("g:inserttag") )
		let g:inserttag =  strftime("%y%m%d")
	endif
	exec "normal a".s:space.s:ccomment.s:signature.g:inserttag.s:space
	"startinsert!
endfunc

nnoremap ,C    :call InsertComment()<CR>
inoremap <C-c> <c-r>=InsertComment()<CR>


"*****************************************************************
" Display
"*****************************************************************

syntax on
"---------------------------------
" 検索関連
"---------------------------------
set ignorecase
set smartcase
set incsearch


"---------------------------------
" 表示関連
"---------------------------------
set sm
set autoindent
set cindent
set smartindent
set number
set hidden
set autoread
set previewheight=5
set hlsearch
set nowrap

set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P

"---------------------------------
" tab 関連
"---------------------------------
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=0
set listchars=tab:>-
set list

"---------------------------------
" 印刷関連
"---------------------------------
set printoptions=wrap:y
set printoptions=number:y
set printoptions=syntax:n

"---------------------------------
" その他
"---------------------------------
set backspace=indent,eol,start
set nobackup
set backupdir=$vim/backup
let autodate_format='%Y/%m/%d %H:%M:%S'
set laststatus=2
set showcmd

"---------------------------------
" 動作設定
"---------------------------------
if has("autochdir")
  set autochdir
  "set tags=~/.vim/systags,tags;
  set tags=tags;
else
  "set tags=~/.vim/systags,./tags,./../tags,./*/tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags
  set tags=./tags,./../tags,./*/tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags
endif


"*****************************************************************
" Key Mapping
"*****************************************************************
ab _perl #!/usr/bin/perl
ab _sh #!/bin/sh
ab _rb #!/usr/bin/ruby -w

"---------------------------------
" Moving
"---------------------------------
nnoremap j gj
nnoremap k gk
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l

"---------------------------------
" Vim tips http://vimwiki.net/?%A5%D7%A5%ED%A5%B0%A5%E9%A5%DF%A5%F3%A5%B0%BB%D9%B1%E7
"---------------------------------
"switch .c <-> .h
nnoremap ,h   :e %:r.h<CR>
"nnoremap ,c   :e %:r.c<CR>
nnoremap ,c   :e %:r.c<CR>
nnoremap ,p   :e %:r.cpp<CR>

"---------------------------------
" thanks to http://hatena.g.hatena.ne.jp/hatenatech/20060515/1147682761
"---------------------------------
" Execute Command
nmap ,e :execute '!' &ft ' %'<CR>

" MiniBufExplorer ? GNU screen like
nnoremap ,1   :e #1<CR>
nnoremap ,2   :e #2<CR>
nnoremap ,3   :e #3<CR>
nnoremap ,4   :e #4<CR>
nnoremap ,5   :e #5<CR>
nnoremap ,6   :e #6<CR>
nnoremap ,7   :e #7<CR>
nnoremap ,8   :e #8<CR>
nnoremap ,9   :e #9<CR>

" Change encoding
noremap ,U :set encoding=utf-8<CR>
noremap ,E :set encoding=euc-jp<CR>
noremap ,S :set encoding=cp932<CR>

" Renew folding
nnoremap ,s :set foldmethod=syntax<CR>

" Vimgrep shortcut
nmap <C-S-*> :vimgrep /<C-R><C-W>/ *.cpp \| cwin <CR>
nmap <F11> :vimgrep /<C-R><C-W>/ *.cpp \| cwin <CR>

"*****************************************************************
" Config for File Type
"*****************************************************************
filetype plugin indent on

"---------------------------------
" For C
"---------------------------------
"autocmd FileType c :set dictionary=opencv.dic<CR>
"autocmd FileType c :set foldmethod=syntax
"autocmd FileType cpp :set dictionary=opencv.dic<CR>
"autocmd FileType cpp :set foldmethod=syntax
autocmd FileType c :map <C-[> <C-w>}
"autocmd FileType c :nmap! <F11> :vimgrep /<C-R><C-W>/ ./**/*.c \| cwin <CR>
"autocmd FileType h :nmap! <F11> :vimgrep /<C-R><C-W>/ ./**/*.h \| cwin <CR>
"autocmd FileType cpp :nmap! <F11> :vimgrep /<C-R><C-W>/ ./**/*.cpp \| cwin <CR>

"---------------------------------
" For Ruby
"---------------------------------
autocmd FileType ruby  :set tabstop     = 2
autocmd FileType ruby  :set softtabstop = 0
autocmd FileType ruby  :set shiftwidth  = 2

"---------------------------------
" For uwsc
"---------------------------------
au BufRead,BufNewFile *.uwsc set filetype=uwsc
au BufRead,BufNewFile *.uws  set filetype=uwsc

"---------------------------------
" For hl7
"---------------------------------
au FileType hl7 :set ff=mac; e!

"---------------------------------
" For vbnet
"---------------------------------
autocmd BufNewFile,BufRead *.vb set ft=vbnet

"---------------------------------
" For markdown
"---------------------------------
au FileType markdown :set expandtab
au FileType markdown :set tabstop=4
au FileType markdown :set softtabstop=0
au FileType markdown :set shiftwidth=4


"*****************************************************************
" Plugin Setting
"*****************************************************************
"---------------------------------
" CD.vim
"---------------------------------
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

"---------------------------------
" plugin minibufexpl
"---------------------------------
let g:miniBufExplMapWindowNavVim    = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBuffs = 1
" from hatena.g.hatena.ne.jp/hatenatech/20060515
let g:miniBufExplSplitBelow         = 0  " Put new window above
let g:miniBufExplModSelTarget       = 1
let g:miniBufExplSplitToEdge        = 1

"---------------------------------
" plugin DoxygetTOolkit
"---------------------------------
let g:DoxygenToolkit_compactDoc = "yes"
let g:DoxygenToolkit_undocTag="DOX_SKIP_BLOCK"
" Author
let g:DoxygenToolkit_authorName="($Author$)"
let g:DoxygenToolkit_licenseString = "Copyright(C) 2012 ."
let g:DoxygenToolkit_versionString = "$Rev$"

" 関数説明
let g:DoxygenToolkit_startCommentTag = "/*! "
let g:DoxygenToolkit_startCommentBlock = "/*! "
let g:DoxygenToolkit_paramTag_pre = "@param[in/out] "
let g:DoxygenToolkit_returnTag="@retval   "
let g:DoxygenToolkit_interCommentTag = ""
let g:DoxygenToolkit_interCommentBlock = ""
let g:DoxygenToolkit_blockHeader = "//----------------------------------------------------------------"
let g:DoxygenToolkit_blockFooter = "//----------------------------------------------------------------"


"---------------------------------
" plugin TagExplorer
" thanks to http://hatena.g.hatena.ne.jp/hatenatech/20060515/1147682761
"---------------------------------
let mapleader = '\'
nnoremap <Leader>l     : TagExplorer<CR>
nnoremap <Leader><C-l> : TagExplorer<CR>


"---------------------------------
" plubin autocomplpop
" http://unsigned.g.hatena.ne.jp/Trapezoid/20070417/p1
"---------------------------------
let g:acp_enableAtStartup = 1
function InsertTabWrapper()
	if pumvisible()
		return "\<c-n>"
	endif
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k\|<\|/'
		return "\<tab>"
	elseif exists('&omnifunc') && &omnifunc == ''
		return "\<c-n>"
	else
		return "\<c-x>\<c-o>"
	endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>


"---------------------------------
" plubin vim-latex
" http://alohakun.blog7.fc2.com/blog-entry-60.html
" http://vim-latex.sourceforge.net/
"---------------------------------
" REQUIRED. This makes vim invoke latex-suite when you open a tex file.
"filetype plugin on
" Enabled before
"
" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse latex-suite. Set your grep
" program to alway generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
"filetype indent on
" Enabled before

" 各自の環境に合わせた .tex ファイルを dvi
" ファイルにコンパイルするコマンドに，適宜置き換えてください． (Vine Linux 3.1 の場合)
let g:Tex_CompileRule_dvi = 'platex $*'
" 同様に，dvi ファイルのビューワー
let g:Tex_ViewRule_dvi = 'pxdvi'

"---------------------------------
" plugin code snippets
" http://www.vim.org/scripts/scripts.php?script_id=2086
"---------------------------------
"let g:CodeSnippet_no_default_mappings = 1
map  <C-CR> <Plug>CodeSnippet_forward
imap <C-CR> <Plug>CodeSnippet_forward
map  <S-CR> <Plug>CodeSnippet_backward
imap <S-CR> <Plug>CodeSnippet_backward


"---------------------------------
" plugin fuzzyfinder 
"---------------------------------
autocmd FileType fuf nmap <C-c> <ESC>
let g:fuf_patternSeparator = ' '
let g:fuf_modesDisable = ['mrucmd']
let g:fuf_mrufile_exclude = '\v\.DS_Store|\.git|\.swp|\.svn'
let g:fuf_mrufile_maxItem = 100
let g:fuf_enumeratingLimit = 20
let g:fuf_file_exclude = '\v\.DS_Store|\.git|\.swp|\.svn'

"fuzzyfinder
nnoremap <Space>f f
nnoremap <Space>F F
nnoremap f <Nop>
nnoremap <unique> <silent> fb :<C-u>FufBuffer!<CR>
nnoremap <unique> <silent> ff :<C-u>FufFile! <C-r>=expand('%:~:.')[:-1-len(expand('%:~:.:t'))]<CR><CR>
nnoremap <unique> <silent> fm :<C-u>FufMruFile!<CR>
"nnoremap <unique> <silent> <C-t> :<C-u>FufFile! <C-r>=expand('%:~:.')[:-1-len(expand('%:~:.:t'))]<CR><CR>
nnoremap <unique> <silent> mf :FufFile <C-r>=expand(g:memolist_path."/")<CR><CR>


"---------------------------------
" plugin Align.vim 
" http://www.vim.org/scripts/script.php?script_id=294
"---------------------------------
:let g:Align_xstrlen = 3

"---------------------------------
" plugin Pukiwiki.vim 
" https://github.com/syngan/vim-pukiwiki
" ---------------------------------

"---------------------------------
" plugin Pukiwiki.vim 
" https://github.com/syngan/vim-pukiwiki
" ---------------------------------
nmap mn  :MemoNew<CR>
nmap ml  :MemoList<CR>
nmap mg  :MemoGrep<CR>
let g:memolist_path = "C:/Memo"
let g:memolist_memo_date = "Created:%Y/%m/%d %H:%M - Last Change:."

