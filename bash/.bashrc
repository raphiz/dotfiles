# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source bash prompt
. ~/.bash_prompt

# Show exit code of the latest command
# if it was not 0.
__sexy_bash_prompt=$PROMPT_COMMAND
PROMPT_COMMAND=__prompt_command

__prompt_command() {
    local curr_exit="$?"

    local BRed='\e[0;91m'
    local RCol='\e[0m'

    if [ "$curr_exit" != 0 ]; then
    	echo -e -n "[${BRed}$curr_exit${RCol}]"
    fi
}
# configure history
export HISTSIZE=900000
export HISTFILESIZE=90000
shopt -s histappend # Append to the history file, don't overwrite it

# setup environment
export PATH=/home/raphiz/.local/bin:$PATH
export EDITOR="${EDITOR:-vim}"

# setup aliases and shortcuts
alias l='ls -lah'
alias top='htop'
alias sudo='sudo ' # See https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias pacman='pacmatic'
alias yay-update='yay -Syu --sudoloop'
alias cat='bat'

function o(){
  xdg-open "$*" >/dev/null 2>&1 &
}
# Autojump
source /etc/profile.d/autojump.bash
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"


# AWS stuff
#  Bash completion (aws cli installt using: `pipx install awscli`)
if [ -f ~/.local/bin/aws_completer ]; then
	complete -C '~/.local/bin/aws_completer' aws
fi
alias awsume=". awsume"
_awsume() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(awsume-autocomplete)
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
complete -F _awsume awsume


# Direnv
eval "$(direnv hook bash)"

# Nix
if [ -e /home/raphiz/.nix-profile/etc/profile.d/nix.sh ]; then . /home/raphiz/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

set +e
for brcfile in ~/.bashrc.d/* ; do
  [ -f "$brcfile" ] && . $brcfile
done
set -e