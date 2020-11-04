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
DEFAULT_USER=uv977zz

# ZSH_THEME="powerlevel9k/powerlevel9k"
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="steeef"
zsh_wifi_signal(){
    local signal=$(airport -I | egrep 'agrCtlRSSI' | egrep -o '[0-9]+')
    # local signal=$(nmcli device wifi | grep yes | awk '{print $8}')
    local color='%F{yellow}'
    [[ $signal -gt 75 ]] && color='%F{red}'
    [[ $signal -lt 50 ]] && color='%F{green}'
    #echo -n "%{$color%}\uf1eb  -$signal%{%f%}" # \uf230 is 
    echo -n "%{$color%}-$signal%{%f%}" # \uf230 is 
}

POWERLEVEL9K_HIDE_BRANCH_ICON="true"
#POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-aheadbehind git-stash git-remotebranch git-tagname)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=5
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_CUSTOM_WIFI_SIGNAL="zsh_wifi_signal"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir newline vcs virtualenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history time root_indicator background_jobs battery custom_wifi_signal)
POWERLEVEL9K_VIRTUALENV_BACKGROUND='227'
POWERLEVEL9K_PYENV_BACKGROUND='092'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='035'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='126'
POWERLEVEL9K_MODE='nerdfont-complete'
# POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_BATTERY_VERBOSE=false
POWERLEVEL9K_BATTERY_HIDE_ABOVE_THRESHOLD=80
POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND=(darkred orange4 yellow4 yellow4 chartreuse3 green3 green4 darkgreen)
POWERLEVEL9K_TIME_ICON=""
POWERLEVEL9K_COLOR_SCHEME='dark'
POWERLEVEL9K_HOME_ICON=''
POWERLEVEL9K_HOME_SUB_ICON=''
POWERLEVEL9K_FOLDER_ICON=''
POWERLEVEL9K_ETC_ICON=''
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=~/workspace
export EDITOR=emacsclient
export CASE_SENSITIVE="true"

# plugins=(npm z copydir copyfile brew osx colorize dirpersist \
# 	     colored-man-pages safe-paste common-aliases)
plugins=(npm z brew osx colorize colored-man-pages safe-paste common-aliases docker docker-compose)

#export LS_COLORS='di=33:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31;7:mi=0;41:ex=93:*.csv=35:*.py=96'
HIST_STAMPS="mm/dd/yyyy"
ENABLE_CORRECTION="false"
# fpath=("${HOME}/src/git-subrepo/share/zsh-completion" $fpath)
# source "${HOME}/src/git-subrepo/.rc"
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
SAVEHIST=200000
HISTSIZE=200000
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/help
autoload -Uz zmv
autoload -Uz bashcompinit
bashcompinit

fpath=(/usr/local/share/zsh-completions $fpath)

[ -f $HOME/zsh_aliases ] && source $HOME/zsh_aliases
[ -f $HOME/zsh_functions ] && source $HOME/zsh_functions
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval $(/usr/local/opt/coreutils/libexec/gnubin/dircolors ${HOME}/src/dircolors-solarized/dircolors.ansi-dark)
eval "$(thefuck --alias)"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
source /usr/local/Cellar/apm-bash-completion/1.0.0/etc/bash_completion.d/apm
# source /usr/local/bin/virtualenvwrapper.sh
source ${HOME}/.iterm2_shell_integration.zsh
source /usr/local/opt/git-extras/share/git-extras/git-extras-completion.zsh
source /Users/${DEFAULT_USER}/src/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /Users/${DEFAULT_USER}/src/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# to prevent:
#  'ascii' codec can't encode character u'\u2026' in position 463: ordinal not in range(128)
# when python program outputs unicode characters and error occurs when piping to most or less
export PYTHONIOENCODING="utf_8"
export HOMEBREW_GITHUB_API_TOKEN="cdba7200b0e3086d3e747dfadc88f4b77588d304"
export FORECAST_API_KEY="a9e7b84c026e83a44c2364c058eb1927"
export ATLASSIAN_CLOUD_REST_API_KEY=Ve4ahaVfrCWx3MQmksAkFF03
export JAVA_HOME=$(/usr/libexec/java_home)
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"



myssid=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')
source ${HOME}/dotfiles/secret
if [[ $myssid = "Qkpwm"* ]]; then
    export ALL_PROXY="http://uv977zz:${tps}@amweb.ey.net:8080"
    gi config --global http.proxy "http://uv977zz:${tps}@amweb.ey.net:8080"
    git config --global https.proxy "https://uv977zz:${tps}@amweb.ey.net:8443"
else
    git config --global --unset http.proxy
    git config --global --unset https.proxy
fi

# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip
# pip zsh completion end


export PATH="/usr/local/opt/ncurses/bin:$PATH"
export PYTHONPATH="/Users/uv977zz/src/tensorflow_models/research:/Users/uv977zz/src/tensorflow_models/research/slim:$PYTHONPATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
pyenv virtualenvwrapper
export PATH="/usr/local/opt/qt/bin:$PATH"

# export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/Users/uv977zz/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/ruby/lib"
# export CPPFLAGS="-I/usr/local/opt/ruby/include"
# export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"
typeset -U PATH
export BETTER_EXCEPTIONS=1
autoload -Uz compinit && compinit -i
# Case insensitive match
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# export PATH="/usr/local/opt/node@10/bin:$PATH"
# eval "$(starship init zsh)"

# Support for bash
PROMPT_COMMAND='prompt'

# Mirrored support for zsh. See: https://superuser.com/questions/735660/whats-the-zsh-equivalent-of-bashs-prompt-command/735969#735969 
precmd() { eval "$PROMPT_COMMAND" }

function prompt()
{
    if [ "$PWD" != "$MYOLDPWD" ]; then
        MYOLDPWD="$PWD"
        test -e .venv && workon `cat .venv`
    fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# # turn off tracing
# unsetopt xtrace
# #restore stderr to the value saved in FD 3
# exec 2>&3 3>&-
export LESSOPEN="|/usr/local/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
#export PATH="/Users/uv977zz/.gem/ruby/2.6.0/bin:${PATH}"
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Created by `userpath` on 2020-06-30 17:26:12
export PATH="$PATH:/Users/uv977zz/.local/bin"
#eval "$(register-python-argcomplete pipx)"
export PATH="/usr/local/opt/node@12/bin:$PATH"
export ARTIFACTORY_KEY='AKCp5fUPMw6ASEG3kVJqrApjokqvRvPHasZd5tzCqtwJfutVq6yQZPeLSH8Lv7pu9e9PRcWV9'
eval "$(register-python-argcomplete pipx)"
