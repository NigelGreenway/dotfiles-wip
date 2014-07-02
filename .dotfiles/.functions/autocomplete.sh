## Auto complete function

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

if [ -f /usr/local/share/doc/task/scripts/bash/task.sh ]; then
    . /usr/local/share/doc/task/scripts/bash/task.sh
fi

complete -W "$(teamocil --list)" teamocil
complete -W "`awk '{ print $2 }' /etc/hosts`" ping
complete -W "`awk '{ print $2 }' /etc/hosts`" ssh