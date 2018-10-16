# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source bash prompt
. ~/.bash_prompt

HISTSIZE=10000
HISTFILESIZE=10000

export PATH=/home/raphiz/.local/bin:/home/raphiz/.yarn/bin:$PATH
export EDITOR='vim';

alias l='ls -lah'
alias top='htop'


alias sudo='sudo ' # See https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias pacman='pacmatic'

# Autojump
source /etc/profile.d/autojump.bash

# Asciidoctor via docker-container
function asciidoctor-pdf {
  asciidoctor_pdf="docker run -ti --rm --user $(id -u) --volume $(pwd):/documents:z asciidoctor/docker-asciidoctor asciidoctor-pdf"
  #asciidoctor_pdf="docker run -ti --rm --user $(id -u) --volume $(pwd):/documents:z asciidoctor/docker-asciidoctor ls -al #asciidoctor-pdf"
  $asciidoctor_pdf "$1"
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
