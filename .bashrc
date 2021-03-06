#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ $DISPLAY ]] && shopt -s checkwinsize

case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

    ;;
  screen*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

source /usr/share/bash-completion/completions/yay
source $HOME/.bash_completion
source $HOME/.bin/fzf-scripts.sh

export FZF_DEFAULT_OPTS='
  --prompt="› "
  --pointer="› "
'

#source $HOME/.bin/fzf-tab-completion.sh
#bind -x '"\t": fzf_bash_completion'

# my export variables, and paths
export VISUAL="vim"
export PATH="${PATH}:$HOME/.local/bin"
export PATH="$HOME/.bin:${PATH}"

# my aliases
alias ls='ls --color=auto'
alias ll='ls -lh'
alias lla='ll -a'

alias le='exa --color=auto'
alias lel='le -l'

alias sudo='sudo -E'
alias dot-config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias mpv='~/.bin/umpv'

GREEN="\[\033[0;32m\]"
BLUE="\[\033[0;34m\]"
RED="\[\033[0;31m\]"
YELLOW="\[\033[1;33m\]"
L_GREEN="\[\033[1;32m\]"
L_BLUE="\[\033[1;34m\]"
L_RED="\[\033[1;31m\]"
WHITE="\[\033[00m\]"

# Emoji's per day
emoji() {
	emo=😡
	day=$(date +%a)
	date=$(date +%d)
	mon=$(date +%b)
	
	#ca
}

exit_status() {
	if [ $? -eq 0 ];then
		echo "$L_GREEN• $YELLOW• $L_BLUE•"
	else
		echo "$YELLOW• $L_RED• $YELLOW•"
	fi

}

char() {
	if [ "$USER" = "root" ];then
		char="$YELLOW#"
	else
		char="$L_BLUE›"
	fi
	echo $char
}

set_prompt() {
		PS1="\n$(exit_status) $L_BLUE\W\n  $(char)$WHITE "
}

PROMPT_COMMAND=set_prompt

# The size of the album art to be displayed
export KUNST_SIZE="250x250"

# The position where the album art should be displayed
export KUNST_POSITION="+0+0"

# Where your music is located
export KUNST_MUSIC_DIR='/mnt/local-data/Media/Music/'

# man-pages coloring
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

PATH="/home/mepowerleo10/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/mepowerleo10/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/mepowerleo10/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/mepowerleo10/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/mepowerleo10/perl5"; export PERL_MM_OPT;

HISTCONTROL=ignoredups:erasedups
shopt -s histappend
PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

MANWIDTH=71

man() {
    local width=$(tput cols)
    [ $width -gt $MANWIDTH ] && width=$MANWIDTH
    env MANWIDTH=$width \
    man "$@"
}

source /home/mepowerleo10/.config/broot/launcher/bash/br
