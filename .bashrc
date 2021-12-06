#!/usr/bin/env bash

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
if [[ -z $PS1 ]] ; then
  return
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=3000
HISTFILESIZE=6000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

UNCOLORED_TEXT="\[\033[00m\]"

BLACK="\[\033[30m\]"
RED="\[\033[31m\]"
GREEN="\[\033[32m\]"
YELLOW="\[\033[33m\]"
BLUE="\[\033[34m\]"
MAGENTA="\[\033[35m\]"
CYAN="\[\033[36m\]"
WHITE="\[\033[37m\]"

BRIGHT_BLACK="\[\033[01;30m\]"
BRIGHT_RED="\[\033[01;31m\]"
BRIGHT_GREEN="\[\033[01;32m\]"
BRIGHT_YELLOW="\[\033[01;33m\]"
BRIGHT_BLUE="\[\033[01;34m\]"
BRIGHT_MAGENTA="\[\033[01;35m\]"
BRIGHT_CYAN="\[\033[01;36m\]"
BRIGHT_WHITE="\[\033[01;37m\]"

# TODO: alternate colors while printing sub-dir names. Keep the slash the same color.
# TODO: give a different symbol for changes, new files, deleted files in git
# TODO: move the user name and current working directory

# kubernetes
export KUBECONFIG=${HOME}/.kube/config
alias k=kubectl
# https://github.com/jonmosco/kube-ps1
# makes kube_ps1 available as a command
# kube_ps1 is used in setting the prompt PS1
KUBE_PS1_FILE=/usr/local/opt/kube-ps1/share/kube-ps1.sh
if [[ -e ${KUBE_PS1_FILE} ]] ; then
  source ${KUBE_PS1_FILE}
fi

export PS1="\
\$(if [[ \$? -ne 0 ]] ; then echo -n '\[\033[01;31m\]' ; fi)\
\$(i=0 ; while [[ i -lt COLUMNS ]] ; do echo -n '_'; : \$((i=i+1)) ; done)\n\
${BRIGHT_YELLOW}|${UNCOLORED_TEXT}\$(if kube_ps1 &>/dev/null ; then echo -n ' ' ; kube_ps1 ; fi) ${BRIGHT_CYAN}\w ${UNCOLORED_TEXT}@ ${BRIGHT_GREEN}\h ${BRIGHT_BLUE}(\u) \
${UNCOLORED_TEXT}[${BRIGHT_MAGENTA}\t${UNCOLORED_TEXT}] \
${BRIGHT_YELLOW}\$(git branch 2>/dev/null | awk '\$1 == \"*\" { print \$2 }') \
${BRIGHT_RED}\$(test \$(git status --porcelain 2>/dev/null | wc -l) -ne 0 && echo -ne \"\xce\x94\") \
\n${BRIGHT_YELLOW}| ${BRIGHT_MAGENTA}\! ${BRIGHT_YELLOW}=> ${UNCOLORED_TEXT}"
export PS2="| => "

# Colored output
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# golang
LENGTH_1="1" # non-zero length
DESIRED_GOPATH=~/gopath
GO_INSTALL_PATH=/usr/local/go
if [[ -z ${GOPATH+LENGTH_1} && -e ${GO_INSTALL_PATH} && -d ${DESIRED_GOPATH} ]] ; then
	export GOPATH=${DESIRED_GOPATH}
fi
unset LENGTH_1
GO_BIN=/usr/local/go/bin/go
GO_BIN_DIR=$(dirname ${GO_BIN})
if [[ -e ${GO_BIN} && ! ${PATH} =~ (:|^)${GO_BIN_DIR}(:|$) ]] ; then
	export PATH=${PATH}:${GO_BIN_DIR}
fi
DEFAULT_GOBIN=~/go/bin
if [[ -d ${DEFAULT_GOBIN} && ! ${PATH} =~ (:|^)${DEFAULT_GOBIN}(:|$) ]] ; then
	export PATH=${PATH}:${DEFAULT_GOBIN}
fi

# Put ~/bin on the path if it exists.
HOMEBIN=~/bin
if [[ -d ~/bin && ! "${PATH}" =~ ${HOMEBIN} ]] ; then
	export PATH=${HOMEBIN}:${PATH}
fi

# Make sure the location of installed Python2 scripts is in PATH
if type python &> /dev/null ; then
  PY_USER_BIN=$(python -c 'import site; print(site.USER_BASE + "/bin")')
  if [[ -n ${PY_USER_BIN} && \
        -e ${PY_USER_BIN} && \
        ! "${PATH}" =~ ${PY_USER_BIN} ]] ; then
    export PATH=${PY_USER_BIN}:${PATH}
  fi
fi
# Make sure the location of installed Python3 scripts is in PATH
if type python3 &> /dev/null ; then
  PY3_USER_BIN=$(python3 -c 'import site; print(site.USER_BASE + "/bin")')
  if [[ -n ${PY3_USER_BIN} && \
        -e ${PY3_USER_BIN} && \
        ! "${PATH}" =~ ${PY3_USER_BIN} ]] ; then
    export PATH=${PY3_USER_BIN}:${PATH}
  fi
fi

# homebrew
put_last_in_path() {
  path="$1"
  putlast="$2"
  echo -n "${path}" | \
    awk -v RS=':' \
        -v ORS=':' \
        -v putlast="${putlast}" \
    '$0 !~ putlast {print}'
  echo "${putlast}"
}
BREW_LOCATIONS=(/opt/homebrew ~/.linuxbrew)
# /usr/local/ is not listed above because I don't want /usr/local/bin/ to be
# put last in the PATH, as the brew location will be after planned future
# changes.
for brew_location in ${BREW_LOCATIONS[@]} ; do
  brew_file=${brew_location}/bin/brew
  if [[ -e ${brew_file} ]] ; then
    eval "$(${brew_file} shellenv)"
    for d in "${brew_location}/bin" "${brew_location}/sbin" ; do
      export PATH=$(put_last_in_path "${PATH}" "${d}")
    done
  fi
done

# pyenv
if type pyenv &> /dev/null ; then
  eval "$(pyenv init -)"
fi

# pipx
DOT_LOCAL_BIN=~/.local/bin
if [[ -d ${DOT_LOCAL_BIN} && ! "${PATH}" =~ ${DOT_LOCAL_BIN} ]] ; then
	export PATH=${DOT_LOCAL_BIN}:${PATH}
fi

# rbenv
# https://github.com/rbenv/rbenv
if type rbenv &> /dev/null ; then
  eval "$(rbenv init -)"
fi
SHIMS_DIR_W_SEP=${HOME}/.rbenv/shims:
export PATH=$(echo "${PATH}" | \
       sed 's%\('${SHIMS_DIR_W_SEP}'\)\{2,\}%'${SHIMS_DIR_W_SEP}'%')

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Python poetry
# https://poetry.eustace.io/
# https://github.com/sdispater/poetry
DOT_POETRY_BIN=~/.poetry/bin
if [[ -d ${DOT_POETRY_BIN} && ! "${PATH}" =~ ${DOT_POETRY_BIN} ]] ; then
	export PATH=${DOT_POETRY_BIN}:${PATH}
fi

# aws cli
alias awscli='docker run --rm -v ~/.aws:/root/.aws amazon/aws-cli:latest'
alias awsman='docker run --rm -it amazon/aws-cli:latest'

function say_path ()
{
  echo $PATH | awk -v RS=':' {print}
}

# company/job/project-specific configuration
COMPANY_CONFIG=/usr/local/etc/profile.sh
if [[ -e ${COMPANY_CONFIG} ]] ; then
  source ${COMPANY_CONFIG}
fi

function dedup_awk ()
{
  echo -n "$1" | awk -v RS=':' -v ORS=':' \
    'a[$0] != 1 { print ; a[$0] = 1 ; }' | \
    sed 's/:$//'
}
DEDUPED_PATH=$(dedup_awk ${PATH})
if [[ "${DEDUPED_PATH}" != "${PATH}" ]] ; then
  export PATH=${DEDUPED_PATH}
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/bin/google-cloud-sdk/path.bash.inc' ]; then . '/usr/local/bin/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/bin/google-cloud-sdk/completion.bash.inc' ]; then . '/usr/local/bin/google-cloud-sdk/completion.bash.inc'; fi

# This silences the warning message about how the default shell is zsh
export BASH_SILENCE_DEPRECATION_WARNING=1
