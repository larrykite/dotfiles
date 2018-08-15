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
POWERLEVEL9K_VIRTUALENV_BACKGROUND='104'
POWERLEVEL9K_PYENV_BACKGROUND='092'
#POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
DEFAULT_USER=uv977zz
#export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export CASE_SENSITIVE="true"

#export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

plugins=(npm z copydir copyfile brew osx colorize dirpersist colored-man-pages safe-paste common-aliases thefuck)
#alias mysql=/usr/local/mysql/bin/mysql
#alias mysqladmin=/usr/local/mysql/bin/mysqladmin
export WORKON_HOME=$HOME/.virtualenvs

#export WORKON_HOME=~/.ve
export PROJECT_HOME=~/workspace
#eval "$(pyenv init -)"
#pyenv virtualenvwrapper

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
    fortune
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
source /usr/local/bin/virtualenvwrapper.sh

source ${HOME}/.iterm2_shell_integration.zsh
eval $(/usr/local/opt/coreutils/libexec/gnubin/dircolors ${HOME}/src/dircolors-solarized/dircolors.ansi-dark)
fpath=(/usr/local/share/zsh-completions $fpath)

[ -f $HOME/zsh_aliases ] && source $HOME/zsh_aliases
[ -f $HOME/zsh_functions ] && source $HOME/zsh_functions

#export ALTERNATIVE_EDITOR=""
#export EDITOR=emacsclient

[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm


export HOMEBREW_GITHUB_API_TOKEN="0152b3ded32eebcc504ae4cbf95069dd8a1d42d5"
export FORECAST_API_KEY="a9e7b84c026e83a44c2364c058eb1927"
eval "$(thefuck --alias)"
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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# # turn off tracing
# unsetopt xtrace
# #restore stderr to the value saved in FD 3
# exec 2>&3 3>&-

# export PATH="/usr/local/opt/curl/bin:$PATH"

export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"

myssid=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')
source ${HOME}/dotfiles/secret
if [[ $myssid = "Qkpwm"* ]]; then
    export ALL_PROXY='http://uv977zz:${tps}@amweb.ey.net:8080'
    git config --global http.proxy 'http://uv977zz:${tps}@amweb.ey.net:8080'
    git config --global https.proxy 'https://uv977zz:${tps}@amweb.ey.net:8443'
else
    git config --global --unset http.proxy 
    git config --global --unset https.proxy 
fi
