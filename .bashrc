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

# my export variables, and paths
export VISUAL="vim"
export PATH="${PATH}:$HOME/.local/bin"

# my aliases
alias ls='ls --color=auto'
alias ll='ls -l'
alias sudo='sudo -E'
alias dot-config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

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
