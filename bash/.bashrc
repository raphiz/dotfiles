# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

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
alias bat='bat --theme=ansi --style="numbers,changes,header"'
alias cat='bat'

function o(){
  xdg-open "$*" >/dev/null 2>&1 &
}
# Autojump
source /etc/profile.d/autojump.bash
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"

# NOTE: Must happen AFTER autojump
# https://github.com/starship/starship/issues/4973
eval "$(starship init bash)"

# Direnv
eval "$(direnv hook bash)"

# Nix
if [ -e /home/raphiz/.nix-profile/etc/profile.d/nix.sh ]; then . /home/raphiz/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

set +e
for brcfile in ~/.bashrc.d/* ; do
  [ -f "$brcfile" ] && . $brcfile
done
