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
alias code='/home/raphiz/apps/VSCode-linux-x64/bin/code'
# Autojump
source /etc/profile.d/autojump.bash

# NVM (temporarily)
# TOO SLOW:
# source /usr/share/nvm/init-nvm.sh
alias source_nvm='unalias node && unalias nvm && unalias npm && source "/usr/share/nvm/init-nvm.sh"'
alias nvm='source_nvm && nvm'
alias node='source_nvm && node'
alias npm='source_nvm && npm'

# Append to the history file, don't overwrite it
shopt -s histappend

# For autojump
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"

function o(){
  xdg-open "$*" >/dev/null 2>&1 &
}
