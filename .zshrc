# # set the trace prompt to include seconds, nanoseconds, script name and line number
# zmodload zsh/datetime
# setopt promptsubst
# PS4='+$EPOCHREALTIME %N:%i> '
# # save file stderr to file descriptor 3 and redirect stderr (including trace 
# # output) to a file with the script's PID as an extension
# exec 3>&2 2>/tmp/startlog.$$
# # set options to turn on tracing and expansion of commands contained in the prompt
# setopt xtrace prompt_subst

ZSH=$HOME/.oh-my-zsh
SYSTYPE=$(uname -s)
# ZSH_THEME="steeef"
ZSH_THEME="powerlevel9k/powerlevel9k"
# POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs pyenv virtualenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_VIRTUALENV_BACKGROUND='yellow'
POWERLEVEL9K_PYENV_BACKGROUND='yellow'
#POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
DEFAULT_USER=uv977zz
#export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export CASE_SENSITIVE="true"

#export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

plugins=(npm z copydir copyfile brew osx colorize dirpersist colored-man-pages safe-paste common-aliases )
#alias mysql=/usr/local/mysql/bin/mysql
#alias mysqladmin=/usr/local/mysql/bin/mysqladmin
# export WORKON_HOME=$HOME/.virtualenvs

export WORKON_HOME=~/.ve
export PROJECT_HOME=~/workspace
eval "$(pyenv init -)"
pyenv virtualenvwrapper

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

setopt noclobber
setopt histallowclobber
setopt dotglob
setopt extendedglob
setopt CSH_NULL_GLOB
#export LS_COLORS='di=33:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31;7:mi=0;41:ex=93:*.csv=35:*.py=96'
SAVEHIST=200000
HISTSIZE=200000
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/help
autoload -Uz bashcompinit
bashcompinit
source /usr/local/Cellar/apm-bash-completion/1.0.0/etc/bash_completion.d/apm
# source /usr/local/share/compleat-1.0/compleat_setup
autoload -Uz zmv
# source /usr/local/bin/virtualenvwrapper.sh

source ${HOME}/.iterm2_shell_integration.zsh
eval $(/usr/local/opt/coreutils/libexec/gnubin/dircolors ${HOME}/src/dircolors-solarized/dircolors.ansi-dark)
fpath=(/usr/local/share/zsh-completions $fpath)

[ -f $HOME/zsh_aliases ] && source $HOME/zsh_aliases
[ -f $HOME/zsh_functions ] && source $HOME/zsh_functions

# compdef '_files -g "*.gz *.tgz *.bz2 *.tbz *.zip *.rar *.tar *.lha"' extract_archive

# bindkey "${terminfo[kcud1]}" history-substring-search-down
# bindkey "${terminfo[kcuu1]}" history-substring-search-up
# zstyle ':completion:*' verbose yes
# zstyle ':completion:*:descriptions' format '%B%d%b'
# zstyle ':completion:*:messages' format '%d'
# zstyle ':completion:*:warnings' format 'No matches for: %d'
# zstyle ':completion:*' group-name


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

typeset -Ag abbreviations
abbreviations=(
  "Im"    "| most"
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
#export ALTERNATIVE_EDITOR=""
#export EDITOR=emacsclient

[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm


export HOMEBREW_GITHUB_API_TOKEN="0152b3ded32eebcc504ae4cbf95069dd8a1d42d5"
export FORECAST_API_KEY="a9e7b84c026e83a44c2364c058eb1927"
# eval "$(thefuck --alias)"
# if brew command command-not-found-init > /dev/null; then eval "$(brew command-not-found-init)"; fi

source /Users/${DEFAULT_USER}/src/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /Users/${DEFAULT_USER}/src/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

#. /Users/larrykite/torch/install/bin/torch-activate

# to prevent:
#  'ascii' codec can't encode character u'\u2026' in position 463: ordinal not in range(128)
# when python program outputs unicode characters and error occurs when piping to most or less
export PYTHONIOENCODING="utf_8"

export JAVA_HOME=$(/usr/libexec/java_home)
typeset -U PATH
# export GEOS_DIR="/usr/local/Cellar/geos/3.6.1/"

# GIT heart FZF
# -------------
if alias gf > /dev/null; then
    unalias gf
    unalias gb
    unalias gr
fi

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 50% "$@" --border
}

gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}

join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

bind-git-helper() {
  local char
  for c in $@; do
    eval "fzf-g$c-widget() { local result=\$(g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N fzf-g$c-widget"
    eval "bindkey '^g^$c' fzf-g$c-widget"
  done
}
bind-git-helper f b t r h
unset -f bind-git-helper

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# # turn off tracing
# unsetopt xtrace
# #restore stderr to the value saved in FD 3
# exec 2>&3 3>&-
