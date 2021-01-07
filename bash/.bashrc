# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source bash prompt
. ~/.bash_prompt

export HISTSIZE=900000
export HISTFILESIZE=90000

export PATH=/home/raphiz/.local/bin:/home/raphiz/.yarn/bin:$PATH
export EDITOR="${EDITOR:-vim}"

alias l='ls -lah'
alias top='htop'

alias sudo='sudo ' # See https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias pacman='pacmatic'
alias yay-update='yay -Syu --sudoloop'

alias xclip='xclip -selection clipboard'

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

function o(){
  xdg-open "$*" >/dev/null 2>&1 &
}


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/raphiz/.sdkman"
[[ -s "/home/raphiz/.sdkman/bin/sdkman-init.sh" ]] && source "/home/raphiz/.sdkman/bin/sdkman-init.sh"

eval "$(direnv hook bash)"

alias bat='bat --theme OneHalfLight'
alias cat='bat'
