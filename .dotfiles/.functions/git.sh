edit-gsm() { $EDITOR $(git status --short | awk '$1 ~ /^MM/ { print $2 }'); }
edit-gsn() { $EDITOR $(git status --short | awk '$1 ~ /^??/ { print $2 }'); }
edit-gsa() { $EDITOR $(git status --short | awk '$1 { print $2 }'); }

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