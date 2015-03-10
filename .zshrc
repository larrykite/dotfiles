# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="larry"
DEFAULT_USER=larry
CASE_SENSITIVE="true"
plugins=(history docker scala vagrant colored-man pip gnu-utils git github python \
    debian cp git-extras zsh-syntax-highlighting z catimg dircycle dirhistory \
    command-not-found history-substring-search)
HIST_STAMPS="mm/dd/yyyy"
ENABLE_CORRECTION="false"
# To make emacs sub-processes, like tramp, act sanely
if [[ "$TERM" == "dumb" ]]
then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
    PS1='$ '
else
    export TERM=xterm-256color
    source $ZSH/oh-my-zsh.sh
fi
SAVEHIST=200000
HISTSIZE=200000
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')

export GOPATH=/home/larry/gocode
export PATH=$PATH:$GOPATH/bin
export DS_NOTEBOOK=notebook
export PYTHONPATH=${HOME}/bin:${HOME}/python:$PYTHONPATH
export PATH=${HOME}/bin:${HOME}/bin/customer:/usr/local/go/bin:${HOME}/dev/julia:${HOME}/dev/csvkit/csvkit/utilities:$PATH
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export BROWSER=$(which chromium-browser)
export R_LIBS="${HOME}/R_libs"

[ -f $HOME/zsh_aliases ] && source $HOME/zsh_aliases
[ -f $HOME/zsh_functions ] && source $HOME/zsh_functions

autoload -Uz bashcompinit
bashcompinit
autoload -Uz zmv
[ -f /etc/bash_completion.d/skytree-server ] && source /etc/bash_completion.d/skytree-server

compdef '_files -g "*.gz *.tgz *.bz2 *.tbz *.zip *.rar *.tar *.lha"' extract_archive
export WORKON_HOME="$HOME/.virtualenvs"
export PROJECT_HOME="$HOME/pyprojects"
export VIRTUAL_ENV_DISABLE_PROMPT=1
[ -f /etc/bash_completion.d/virtualenvwrapper ] && source /etc/bash_completion.d/virtualenvwrapper
# [ -f "${HOME}/.bash_completion.d/python-argcomplete.sh" ] && source "${HOME}/.bash_completion.d/python-argcomplete.sh"
# [ -f "${HOME}/bin/SCO-completion-script.sh" ] && source "${HOME}/bin/SCO-completion-script.sh"

bindkey "${terminfo[kcud1]}" history-substring-search-down
bindkey "${terminfo[kcuu1]}" history-substring-search-up




zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name
fpath=(
	$fpath
    /home/larry/.zsh/completion
    /media/bigdisk/src/zsh-completions
	/home/larry/.zen/zsh/scripts
	/home/larry/.zen/zsh/zle )
autoload -U zen
# only update zen on Mondays
# if [[ $(date +%u) == 1 ]]; then
#     zen update
# fi
#source ~/src/powerline/powerline/bindings/zsh/powerline.zsh
unalias run-help
autoload run-help
setopt dotglob
HELPDIR=${HOME}/zsh_help

# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# ------------------------------------------------
cb() {
  local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
  # Check user is not root (root doesn't have access to user xorg server)
  elif [[ "$USER" == "root" ]]; then
    echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
  else
    # If no tty, data should be available on stdin
    if ! [[ "$( tty )" == /dev/* ]]; then
      input="$(< /dev/stdin)"
    # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then  # If no input, print usage message.
      echo "Copies a string to the clipboard."
      echo "Usage: cb <string>"
      echo "       echo <string> | cb"
    else
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
    fi
  fi
}
# Aliases / functions leveraging the cb() function
# ------------------------------------------------
# Copy contents of a file
function cbf() { cat "$1" | cb; }
# Copy SSH public key
alias cbssh="cbf ~/.ssh/id_rsa.pub"
# Copy current working directory
alias cbwd="pwd | cb"
# Copy most recent command in bash history
alias cbhs="fc -l | tail -n 1 | sed -e 's/^[0-9 ]\+//' | cb"
# remove duplicates from PATH
typeset -U PATH
export VAGRANT_HOME='/media/bigdisk/vagrant.d'
eval $(dircolors ${HOME}/src/dircolors-solarized/dircolors.ansi-dark)

# disable backspace key (to encourage exclusive use of caps-lock as BS)
xmodmap -e 'keycode 22 = NoSymbol'

typeset -Ag abbreviations
abbreviations=(
  "Im"    "| more"
  "Ia"    "| awk"
  "Ig"    "| grep"
  "Ieg"   "| egrep"
  "Iag"   "| agrep"
  "Igr"   "| groff -s -p -t -e -Tlatin1 -mandoc"
  "Ip"    "| $PAGER"
  "Ih"    "| head"
  "Ik"    "| keep"
  "It"    "| tail"
  "Is"    "| sort"
  "Iv"    "| ${VISUAL:-${EDITOR}}"
  "Iw"    "| wc"
  "Ix"    "| xargs"
  "Ish"   "| sort -h"
)

magic-abbrev-expand() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    zle self-insert
}

no-magic-abbrev-expand() {
  LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand
bindkey -M isearch " " self-insert
setopt CSH_NULL_GLOB
source /home/larry/src/zaw/zaw.zsh

[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
