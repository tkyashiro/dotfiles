# environmen
#source ~/.env.linux
source ~/.env.win

# alias
source ~/.alias
## 既存コマンドの置き換え
#source ~/.func.linux
source ~/.func.win

function cd() { builtin cd $@ && ls; }
function lless () { ls -l -h $@ | less; }
function nless() { nkf -w $@ | less; }
function dusort() {du -k --max-depth=1 | sort -rn | less$@}

alias ls='ls --color=auto'
alias la='ls -a'

# Grobal alias
alias -g L=' | less'
alias -g H=' | head'
alias -g T=' | tail'
alias -g G=' | grep'
alias -g W=' | wc'

## thanks to http://chasen.org/~daiti-m/text/zsh-intro.html
setopt autopushd
alias gd='dirs -v ; echo -n "select number : "; read newdir; cd -"$newdir"'

###################################
#  Settings
###################################

# http://q-eng.imat.eng.osaka-cu.ac.jp/~ippei/unix/zsh.html
bindkey -e

autoload -U compinit;
compinit -u
#### history
HISTFILE="$HOME/.zhistory"      # 履歴ファイル
HISTSIZE=10000                  # メモリ上に保存される $HISTFILE の最大サイズ？
SAVEHIST=10000                  # 保存される最大履歴数

#### option, limit, bindkey
setopt pushd_ignore_dups
setopt  hist_ignore_all_dups    # 既にヒストリにあるコマンド行は古い方を削除
setopt  hist_reduce_blanks      # コマンドラインの余計なスペースを排除
setopt  share_history           # ヒストリの共有

## PROMPT
### http://homepage1.nifty.com/blankspace/zsh/zsh.html
setopt prompt_subst
precmd() {
	hostnam=${HOST##.*}     # wildcard, not regex!
	usernam=$(whoami)
	newPWD=${PWD}
	#   アクセサリをつけていく
	promptstr="[${usernam}@${hostnam}-(mm/dd hh:mm)](${PWD})-"
	fillsize=$(( ${COLUMNS} - ${#promptstr} - 1 ))      # プロンプト幅を計算
	if [ $fillsize -ge 0 ]
	then
		fill=${(l.${fillsize}.. .)}
	else
		fill=""
		offset=$(( (${fillsize}*(-1)) + 4 ))
		newPWD="..."${newPWD[${offset},-1]}
	fi
PROMPT=%{[$[32+$RANDOM % 5]m%}[\${usernam}@\${hostnam}\
"-(%D{%m}/%D{%d} %D{%H}:%D{%M})]"\
"\${fill}(\${newPWD})-%{[m%}"\
$'\n'\
"-[%h]%#"\
$'%{\e[0m%} '
}

#
## for screen
if [ "$TERM" = "screen" ]; then
	#chpwd () { echo -n "_`dirs`\\" }
	preexec() {
		# see [zsh-workers:13180]
		# http://www.zsh.org/mla/workers/2000/msg03993.html
		emulate -L zsh
		local -a cmd; cmd=(${(z)2})
		case $cmd[1] in
			fg)
				if (( $#cmd == 1 )); then
					cmd=(builtin jobs -l %+)
				else
					cmd=(builtin jobs -l $cmd[2])
				fi
				;;
			%*) 
				cmd=(builtin jobs -l $cmd[1])
				;;
			cd)
				if (( $#cmd == 2)); then
					cmd[1]=$cmd[2]
				fi
				;;
			*)
				echo -n "k$cmd[1]:t\\"
				return
				;;
		esac

		local -A jt; jt=(${(kv)jobtexts})

		$cmd >>(read num rest
			cmd=(${(z)${(e):-\$jt$num}})
			echo -n "k$cmd[1]:t\\") 2>/dev/null
	}
	#chpwd
fi

# http://d.hatena.ne.jp/naoya/20051223/1135351050
function ssh_screen(){
	eval server=\${$#}
	screen -t $server ssh "$@"
}

if [ x$TERM = xscreen ]; then
	alias ssh=ssh_screen
fi

setopt AUTO_CD
setopt CORRECT_ALL

# http://q-eng.imat.eng.osaka-cu.ac.jp/~ippei/unix/#l13
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

