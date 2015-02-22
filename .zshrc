# Some of the Zsh awesomeness seen below was originally found here...
# http://zanshin.net/2013/02/02/zsh-configuration-from-the-ground-up/

# Variables {{{
# dropbox="$HOME/Dropbox"
# syncfolder="$HOME/Box Sync" # sourcing a file breaks with backslashes
# }}}

# Exports {{{
export PATH=~/bin:/usr/local/bin:/usr/local/mysql/bin:/usr/local/sbin:$HOME/.composer/vendor/bin:$HOME/pear/bin:$HOME/.phpenv/bin:$PATH
export PATH="/usr/local/share/npm/bin:$PATH" # Fixes issue where updating NPM causes wrong bin path to be picked up
export NETWORK_LOCATION="$(/usr/sbin/scselect 2>&1 | egrep '^ \* ' | sed 's:.*(\(.*\)):\1:')" # Use for network location specific functions if needed
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
export EDITOR="subl"
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad
export LS_COLORS=Gxfxcxdxbxegedabagacad
## Users {{
export ghuser="smilinmonki666"
## }}
## quickswitch {{
export sites=/Volumes/Sites
export dotfiles=$HOME/Documents/Projects/Dotfiles
export freshinstall=$HOME/Documents/Fresh\ Install
export vi=vim
## }}
# }}}
# Network {{{
# }}}

# Tmux {{{
# Makes creating a new tmux session (with a specific name) easier
function tmuxopen() {
  tmux attach -t $1
}

# Makes creating a new tmux session (with a specific name) easier
function tmuxnew() {
  tmux new -s $1
}

# Makes deleting a tmux session easier
function tmuxkill() {
  tmux kill-session -t $1
}
# }}}

# Alias' {{{
## General
alias r="source ~/.zshrc && clear"
alias tmuxsrc="tmux source-file ~/.tmux.conf"
alias vi="vim"
alias phplint='find ./ -name \*.php | xargs -n 1 php -l'
alias currentwifi='networksetup -getairportnetwork en0'
alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias localip='ipconfig getifaddr en0'
alias ct="ctags -R --exclude=.git --exclude=node_modules"
alias irc="irssi"
alias mysql="mysql -uroot -p"
## Vagrant
alias vs="vagrant suspend"
alias vu="vagrant up"
alias vd="vagrant destroy"
alias vr="vagrant box remove responsive virtualbox"
alias vst="vagrant status"
alias vsh="vagrant ssh"
## Apache
alias apache-s="sudo apachectl start"
alias apache-r="sudo apachectl restart"
alias apache-rg="sudo apachectl graceful"
alias apache-e="sudo apachectl stop"
alias apache-eg="sudo apachectl graceful-stop"
alias apache-t="sudo apachectl configtest"
## Nginx
alias nginx-s="/usr/bin/nginx"
alias nginx-r="/usr/bin/nginx -s stop && nginx-s"
alias nginx-e="nginx-s -t"
## MySQL
mysqlVersion() {
  version=`mysql --version|awk '{split($0,array," ")} END{print array[5]}'`
  echo "$version"|awk '{split($0,array,",")} END{print array[1]}'
}
mysqlVersionNumber=`mysqlVersion`
alias mysql-stop="/usr/local/cellar/mysql/$mysqlVersionNumber/support-files/mysql.server stop"
alias mysql-start="/usr/local/cellar/mysql/$mysqlVersionNumber/support-files/mysql.server start"

## Git
alias conflicts="$EDITOR `git s|grep 'both modified'|cut -d: -f2`"
# }}}

# Miscellaneous {{{
## System {{
capture--save() {
    screencapture -iW ~/Desktop/screen.png
}

capture() {
    screencapture -iWc
}

dnsflush() {
    dscacheutil -flushcache
}
function restart_finder() {
  killall Finder
}

function show_hidden_files() {
  defaults write com.apple.finder AppleShowAllFiles TRUE
  restart_finder
}

function hide_hidden_files() {
  defaults write com.apple.finder AppleShowAllFiles FALSE
  restart_finder
}

# find shorthand
# find ./ -name '*.js'
function f() {
  find . -name "$1"
}

# Create a new directory and enter it
function md() {
  mkdir -p "$@" && cd "$@"
}
# }}


## Webservers {{
__='
  websever switch
'
switchserv() {
    servType=$1
    if [ $servType == "apache" ]; then
        nginx-e
        apache-s
    fi
    if [ $servType == "nginx" ]; then
        apache-e
        nginx-s
    fi
}

__='
  Bench marking via apache hosted sites

  $1 int      Amount of requests thrown at the site
  $2 string   URL of site for benchmarking
'
apache-bm(){
    "ab -n $1 -c 5 $2"
}

__='
  Create instance of php websever with chosen port
  @param integer Port of server (Default=8000)
  $param string  Web directory of server
'
php-s(){
  php -S localhost:"$1" -t "$2"
}
# }}

## taskwarrior {{
t--a() { task count }

t--p(){ task status:pending count }

t--a(){ task status:active count }

t--c(){ task status:completed count }
#}}
# }}}

# Symfony {{{
sf() { ./app/console "$@"; }
sfmigration() { $EDITOR `sf doctrine:migrations:generate | awk -F"\"" '{ print $2 }'`; } # Opens migration file in your chosen editor
sfmigrate() { sf doctrine:migrations:migrate; } # Migrates the database to the latest version
sfserve() { sf server:run 0.0.0.0:$1; }
# }}}

# Git {{{
gsm() { $EDITOR $(git status --short | awk '$1 ~ /^MM/ { print $2 }'); }
gsn() { $EDITOR $(git status --short | awk '$1 ~ /^??/ { print $2 }'); }
gsa() { $EDITOR $(git status --short | awk '$1 { print $2 }'); }
__='
  Parse files before commiting
'
gitLint() {

  replace=$1

  if git rev-parse --verify HEAD >/dev/null 2>&1
  then
      against=HEAD
  else
      # Initial commit: diff against an empty tree object
      against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
  fi

IFS='
'
  # get a list of staged files
  for line in $(git diff-index --cached --full-index $against)
  do
      # echo "$line"
      # split needed values
      sha=$(echo $line | cut -d' ' -f4)
      temp=$(echo $line | cut -d' ' -f5)
      fileStatus=$(echo $temp | cut -d$'\t' -f1)
      filename=$(echo $temp | cut -d$'\t' -f2)

      if [[ ! -z $replace ]]
      then
        filename="${filename/$replace/}"
      fi

      # file extension
      ext=$(echo $filename | sed 's/^.*\.//')

      # do not check deleted files
      if [ $status = "D" ]
      then
          continue
      fi

      # files with php extension
      if [ $ext = "php" ]
      then
          php -l $filename
      fi

      # files with ruby extension
      if [ $ext = "rb" ]
      then
          ruby -c $filename
      fi

      # files with python extension
      if [ $ext = "py" ]
      then
          python -m py_compile $filename
      fi

  done
}

__='
  Get a list of git repositories that are dirty

  $1 string   The filepath of where to check for dirty repo`s
  $2 int      Amount of directories deep to search
'
function git--report {
    if ! [[ -d $1 ]]; then
        echo 'Invalid directory path given...'
        return 1
    fi
    if ! [[ -z $2 ]]; then
        for f in $(find "$1" -maxdepth $2 -name .git -type d -prune)
        do
            if [ $(find "$f" -type d | grep 'vendor' ) ]
            then
                continue
            fi
            cd "$f/.."
            if ! [ $(git status | grep 'nothing to commit') ]
            then
                echo "$(pwd) has amended & uncommitted changes"
            fi
        done
    else
        for f in $(find "$1" -name .git -type d -prune)
        do
            if [ $(find "$f" -type d | grep 'vendor' ) ]
            then
                continue
            fi
            cd "$f/.."
            if ! [ $(git status | grep 'nothing to commit') ]
            then
                echo "$(pwd) has amended & uncommitted changes"
            fi
        done
    fi
}

function git--count() { git diff $1 --numstat | wc -l }

function git--getLastCommitHash() {    
    if $(is_empty $1); then
          STEP=1
      else
          STEP=$1
    fi
    
    local HASH=`git log --format="%H" -n "$STEP"`
    echo "$HASH" \
        | cut -c1-8
}

__='
  
'
function gbc() { $EDITOR grealpath $(git show --name-only $1|cut -d' ' -f3) }
# }}}

# Auto Completion {{{
autoload -U compinit && compinit
zmodload -i zsh/complist

# man zshcontrib
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:*' enable git #svn cvs

# Enable completion caching, use rehash to clear
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# Fallback to built in ls colors
zstyle ':completion:*' list-colors ''

# Make the list prompt friendly
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'

# Make the selection prompt friendly when there are a lot of choices
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Add simple colors to kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

zstyle ':completion:*' menu select=1 _complete _ignored _approximate

# insert all expansions for expand completer
# zstyle ':completion:*:expand:*' tag-order all-expansions

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:scp:*' tag-order files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show
# }}}

# Key Bindings {{{
# Make the delete key (or Fn + Delete on the Mac) work instead of outputting a ~
bindkey '^?' backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "\e[3~" delete-char

# Make the `beginning/end` of line and `bck-i-search` commands work within tmux
bindkey '^R' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
# }}}

# Colours {{{
autoload colors; colors

# The variables are wrapped in \%\{\%\}. This should be the case for every
# variable that does not contain space.
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
  eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
  eval PR_BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done

eval RESET='$reset_color'
export PR_RED PR_GREEN PR_YELLOW PR_BLUE PR_WHITE PR_BLACK
export PR_BOLD_RED PR_BOLD_GREEN PR_BOLD_YELLOW PR_BOLD_BLUE
export PR_BOLD_WHITE PR_BOLD_BLACK

# Clear LSCOLORS
unset LSCOLORS
# }}}

# Set Options {{{
# ===== Basics
setopt no_beep # don't beep on error
setopt interactive_comments # Allow comments even in interactive shells (especially for Muness)

# ===== Changing Directories
setopt auto_cd # If you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt cdablevarS # if argument to cd is the name of a parameter whose value is a valid directory, it will become the current directory
setopt pushd_ignore_dups # don't push multiple copies of the same directory onto the directory stack

# ===== Expansion and Globbing
setopt extended_glob # treat #, ~, and ^ as part of patterns for filename generation

# ===== History
setopt append_history # Allow multiple terminal sessions to all append to one zsh command history
setopt extended_history # save timestamp of command and duration
setopt inc_append_history # Add comamnds as they are typed, don't wait until shell exit
setopt hist_expire_dups_first # when trimming history, lose oldest duplicates first
setopt hist_ignore_dups # Do not write events to history that are duplicates of previous events
setopt hist_ignore_space # remove command line from history list when first character on the line is a space
setopt hist_find_no_dups # When searching history don't display results already cycled through twice
setopt hist_reduce_blanks # Remove extra blanks from each command line being added to history
setopt hist_verify # don't execute, just expand history
setopt share_history # imports new commands and appends typed commands to history

# ===== Completion
setopt always_to_end # When completing from the middle of a word, move the cursor to the end of the word
setopt auto_menu # show completion menu on successive tab press. needs unsetop menu_complete to work
setopt auto_name_dirs # any parameter that is set to the absolute name of a directory immediately becomes a name for that directory
setopt complete_in_word # Allow completion from within a word/phrase

unsetopt menu_complete # do not autoselect the first completion entry

# ===== Correction
setopt correct # spelling correction for commands
setopt correctall # spelling correction for arguments

# ===== Prompt
setopt prompt_subst # Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt transient_rprompt # only show the rprompt on the current prompt

# ===== Scripts and Functions
setopt multios # perform implicit tees or cats when multiple redirections are attempted
# }}}

# Prompt {{{
function virtualenv_info {
  [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function prompt_char {
  git branch >/dev/null 2>/dev/null && echo '±' && return
  hg root >/dev/null 2>/dev/null && echo '☿' && return
  echo '○'
}

function box_name {
  [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

# http://blog.joshdick.net/2012/12/30/my_git_prompt_for_zsh.html
# copied from https://gist.github.com/4415470
# Adapted from code found at <https://gist.github.com/1712320>.

#setopt promptsubst
autoload -U colors && colors # Enable colors in prompt

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"
GIT_PROMPT_PREFIX="%{$fg[green]%} [%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}u%{$reset_color%}"
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}m%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg_bold[green]%}s%{$reset_color%}"

# Show Git branch/tag, or name-rev if on detached head
function parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
function parse_git_state() {
  # Compose this value via multiple conditional appends.
  local GIT_STATE=""

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi

  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi

  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi
}

# If inside a Git repository, print its branch and state
function git_prompt_string() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "on %{$fg[blue]%}${git_where#(refs/heads/|tags/)}$(parse_git_state)"
}

function current_pwd {
  echo $(pwd | sed -e "s,^$HOME,~,")
}

# Original prompt with User name and Computer name included...
# PROMPT='
# ${PR_GREEN}%n%{$reset_color%} %{$FG[239]%}at%{$reset_color%} ${PR_BOLD_BLUE}$(box_name)%{$reset_color%} %{$FG[239]%}in%{$reset_color%} ${PR_BOLD_YELLOW}$(current_pwd)%{$reset_color%} $(git_prompt_string)
# $(prompt_char) '

PROMPT='${PR_GREEN}.%{$reset_color%} ${PR_BOLD_YELLOW}$(current_pwd)%{$reset_color%} $(git_prompt_string)
$(prompt_char) '

export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color [(y)es (n)o (a)bort (e)dit]? "

function php_version() {
  php=( $(php -i | grep 'PHP Version') )
  echo $php[4]
}

parse_ip_address() {
    local ip="ifconfig en0 | awk '/status/ {print $2}'"
    if [[ $ip =~ active ]]; then
        ifconfig en0 | awk '/inet / {print $2}'
    else
        ifconfig en1 | awk '/inet / {print $2}'
    fi
}

RPROMPT='${PR_GREEN}phpenv: $(php_version)%{$reset_color%}'
# }}}

# History {{{
HISTSIZE=10000
SAVEHIST=9000
HISTFILE=~/.zsh_history
# }}}

# Zsh Hooks {{{
function precmd {
  # vcs_info
  # Put the string "hostname::/full/directory/path" in the title bar:
  echo -ne "\e]2;$PWD\a"

  # Put the parentdir/currentdir in the tab
  echo -ne "\e]1;$PWD:h:t/$PWD:t\a"
}

function set_running_app {
  printf "\e]1; $PWD:t:$(history $HISTCMD | cut -b7- ) \a"
}

function preexec {
  set_running_app
}

function postexec {
  set_running_app
}
# }}}

# Zsh Sourced {{{
# brew install zsh-syntax-highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.phpbrew/bashrc
# }}}

if [[ "$TERM" != "screen-256color" ]]; then
  tmux
  clear
fi
