# Exports {{{
export PATH=~/bin:/usr/local/bin:/usr/local/mysql/bin:/usr/local/sbin:$HOME/.composer/vendor/bin:$HOME/pear/bin:$PATH
export EDITOR=subl
# }}}

# Alias {{{
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
## Autocomplete
complete -W "$(teamocil --list)" teamocil
complete -W "`awk '{ print $2 }' /etc/hosts`" ping
complete -W "`awk '{ print $2 }' /etc/hosts`" ssh
## PHP
alias phplint='find . -name "*.php" -exec php -l {} \; | grep "Parse error"'
# }}}

# Functions {{{
## Symfony {{
sf() { ./app/console "$@"; }
sfmigration() { $EDITOR `sf doctrine:migrations:generate | awk -F"\"" '{ print $2 }'`; } # Opens migration file in your chosen editor
sfmigrate() { sf doctrine:migrations:migrate; } # Migrates the database to the latest version
sfserve() { sf server:run 0.0.0.0:$1; }
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

# mysql {{
mysql--column-search(){ echo "SELECT table_name FROM information_schema.columns WHERE column_name = '$1' AND table_schema = '$2'"|mysql -uroot -p; }
# }}

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

# !hint: Remember, you can always use `cmd + shift + .` to show hidden files in save dialogs
# Param: YES|NO
hiddenfiles() {
    defaults write com.apple.finder AppleShowAllFiles $1
    killall Finder
    clear
}

flatdock() {
    defaults write com.apple.dock no-glass -boolean $1
    killall Dock
}

switchfnkey() {
    fn=`defaults read -g com.apple.keyboard.fnState`
    if [[ $fn == '0' ]]
        then
        defaults write -g com.apple.keyboard.fnState -boolean true
        echo 'fn key enabled'
    else
        defaults read -g com.apple.keyboard.fnState -boolean false
        echo 'fn key disabled'
    fi
}

allowgatekeeper() {
    if [[ $1 == 'yes' ]]
    then
        sudo spctl --master-enable
    elif [[ $1 == 'no' ]]
    then
        sudo spctl --master-disable
    fi
}
#}}

## taskwarrior {{
t--a() {
    task count
}

t--p(){
    task status:pending count
}

t--a(){
    task status:active count
}

t--c(){
    task status:completed count
}
#}}

## git {{
gsm() { $EDITOR $(git status --short | awk '$1 ~ /^MM/ { print $2 }'); }
gsn() { $EDITOR $(git status --short | awk '$1 ~ /^??/ { print $2 }'); }
gsa() { $EDITOR $(git status --short | awk '$1 { print $2 }'); }

__='
  Get a list of git repositories that are dirty

  $1 string   The filepath of where to check for dirty repo`s
  $2 int      Amount of directories deep to search
'
function git--report {
    if ! [[ -d $1 ]]; then
        echo 'Invalid directory path given...'
        return 1
    ME
    fi
    if ! [[ -z $2 ]]; then
        for f in $(find $1 -maxdepth $2 -name .git -type d -prune)
        do
            if [[ $(find $f -type d | grep 'vendor' ) ]]
            then
                continue
            fi
            cd "$f/.."
            if ! [[ $(git status | grep 'nothing to commit') ]]
            then
                echo "$(pwd) has amended & uncommitted changes"
            fi
        done
    else
        for f in $(find $1 -name .git -type d -prune)
        do
            if [[ $(find $f -type d | grep 'vendor' ) ]]
            then
                continue
            fi
            cd "$f/.."
            if ! [[ $(git status | grep 'nothing to commit') ]]
            then
                echo "$(pwd) has amended & uncommitted changes"
            fi
        done
    fi
}

function git--count() {
    git diff $1 --numstat | wc -l
}

function git--getLastCommitHash() {
    
    if $(is_empty $1)
        then
            STEP=1
        else
            STEP=$1
    fi
    
    local HASH=`git log --format="%H" -n "$STEP"`
    echo "$HASH" \
        | cut -c1-8
}
# }}
# }}}

for file in $(find -L $HOME/Autocomplete -type f)
do
    source $file
done
