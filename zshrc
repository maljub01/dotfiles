# Set up the prompt
autoload -Uz promptinit
promptinit
prompt walters

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=10000

# Prevent duplicate commands (or commands starting with a space) from being saved in the history
setopt histignoredups histignorespace

# Cause typed commands to be appended to $HISTFILE (like specifying INC_APPEND_HISTORY) as well as importing new commands from it.
# The history lines are also output with timestamps ala EXTENDED_HISTORY.
setopt SHARE_HISTORY

# Bind the up and down arrow keys to local history.
bindkey '^[[A' up-line-or-local-history
bindkey '^[[B' down-line-or-local-history
up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-local-history
down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-local-history


# Configure the prompt
PROMPT=$'%{${fg[cyan]}%}%B%n@%m%b%{${fg[default]}%}%# '
RPROMPT='%{${fg[cyan]}%}%B%~%b$(prompt_git_info)%{${fg[default]}%} %D{%a %b %d}, %T$(battery_status)'

# Turn on interactive comments
setopt interactivecomments

# Initialize colors.
autoload -U colors
colors

# Set directory stack options
DIRSTACKSIZE=8
setopt autopushd pushdminus pushdsilent pushdtohome
# autopushd:    makes cd act like pushd (puts the current directory on the stack, and changes to a new one)
# pushdsilent:  keeps the shell from printing the directory stack each time we do a cd (pushd)
# pushdtohome:  makes pushd (cd) go to home if no arg is provided
# pushdminus:   allows us to do something like "cd -7" to go back 7 directories (without this option, we would have to use "cd +7" which is not as intuitive).
# Note: expressions like "=4" will be expanded to the 4th directory in the directory stack
alias dh='dirs -v' # Displays the directory stack, vertically and with numbering.

# TODO: check out the following shell option configurations:
# setopt   autocd beep extendedglob nomatch notify
# setopt   globdots correct cdablevars autolist
# setopt   correctall recexact longlistjobs
# setopt   autoresume noclobber
# setopt   rcquotes mailwarning
# unsetopt bgnice autoparamslash


# Function to give the current directory a nickname that would be used in the prompt. This is useful when you're the directory path is too long, making the prompt annoying to look at.
namedir () { export $1=$PWD ;  : ~$1 }
# TODO: make namedir persistent by saving the names to a file, and provide
#       renamedir and delnamedir functionalities.

fpath=(~/.zsh/functions $fpath)
# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
for func in $^fpath/*(N-.x:t); autoload -U $func

# Allow for functions in the prompt.
setopt PROMPT_SUBST

# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'

# Use modern completion system
autoload -Uz compinit
compinit

# TODO: Completion needs some work
# zstyle ':completion:*' auto-description 'specify: %d'
# zstyle ':completion:*' completer _list _expand _complete _match
# zstyle ':completion:*' completions 1
# zstyle ':completion:*' glob 1
# zstyle ':completion:*' format 'Completing %d'
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*' menu select=2
# eval "$(dircolors -b)"
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#
# zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
#
# zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
# zstyle ':completion:*' menu select=long
# zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# zstyle ':completion:*' use-compctl false
# zstyle ':completion:*' verbose true
# zstyle ':completion:*' match-original both
# zstyle ':completion:*' substitute 1
# zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

if [ -f ~/.profile ]; then
  source ~/.profile
fi
