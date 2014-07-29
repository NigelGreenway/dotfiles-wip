export PATH=~/bin:/usr/local/bin:/usr/local/mysql/bin:/usr/local/sbin:/Users/Nigel/.composer/vendor/bin:/Users/Nigel/pear/bin:$PATH
EDITOR=subl

source ~/.rvm/scripts/rvm

if [ -d $HOME/.dotfiles ];
then
    for file in $(find -L ~/.dotfiles -type f)
    do
        if [[ $file == *.sh ]]
        then
            source  "$file"
        fi
    done
fi
clear

parse_git_branch() {
    git_status="`git status -unormal 2>&1`"
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        echo "($(git rev-parse --abbrev-ref HEAD)) |"
    fi
}

parse_ip_address() {
    local ip="ifconfig en0 | awk '/status/ {print $2}'"
    if [[ $ip =~ active ]]; then
        ifconfig en0 | awk '/inet / {print $2}'
    else
        ifconfig en1 | awk '/inet / {print $2}'
    fi
}

battery() {
    ioreg -n AppleSmartBattery -r | awk '$1~/Capacity/{c[$1]=$3} END{OFMT="%.2f%%"; max=c["\"MaxCapacity\""]; print (max>0? 100*c["\"CurrentCapacity\""]/max: "?")}'
}

export PS1="$RED\$echo \${PWD##*/} $YELLOW\$(parse_git_branch)$RED \$(date +%H:%M)$YELLOW |$GREEN \$(parse_ip_address)$YELLOW |$GREEN \$(battery)\n$WHITE \$ "
