# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source bash prompt
. ~/.bash_prompt

export HISTSIZE=10000
export HISTFILESIZE=10000

export PATH=/home/raphiz/.local/bin:/home/raphiz/.yarn/bin:$PATH
export EDITOR='vim';

alias l='ls -lah'
alias top='htop'

alias sudo='sudo ' # See https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias pacman='pacmatic'
alias yay-update='yay -Syu --sudoloop'

# Autojump
source /etc/profile.d/autojump.bash

# Asciidoctor via docker-container
function asciidoctor-pdf {
  asciidoctor_pdf="docker run -ti --rm --user $(id -u) --volume $(pwd):/documents:z asciidoctor/docker-asciidoctor asciidoctor-pdf"
  #asciidoctor_pdf="docker run -ti --rm --user $(id -u) --volume $(pwd):/documents:z asciidoctor/docker-asciidoctor ls -al #asciidoctor-pdf"
  $asciidoctor_pdf "$1"
}

function json_unescape {
  read body
  jq -n --arg msg "$body" '$msg | fromjson'
}

function json_escape {
  jq ".| @json"
}

# Append to the history file, don't overwrite it
shopt -s histappend

# For autojump
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"

# Complete AWS CLI (installed via pip)
if [ -f ~/.local/bin/aws_completer ]; then
	complete -C '~/.local/bin/aws_completer' aws
fi

function o(){
  xdg-open "$*" >/dev/null 2>&1 &
}

