# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

HISTSIZE=10000
HISTFILESIZE=10000

export PATH
export EDITOR='vim';

alias l='ls -lah'
alias top='htop'

# Append to the history file, don't overwrite it
shopt -s histappend

# Record each line as it gets issued
PROMPT_COMMAND='history -a'

function o(){
  xdg-open "$*" >/dev/null 2>&1 &
}
