# # !OS X Specific!

capture--save() {
    screencapture -iW ~/Desktop/screen.png
}

capture() {
    screencapture -iWc
}

dnsflush() {
    dscacheutil -flushcache
}

# Remember, you can always use `cmd + shift + .` to show hidden files in save dialogs
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