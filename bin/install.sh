##################################
##  Simple & dirty install script
##################################
function install_personal_dotfiles() {
	cp -r .bash_partials/ $HOME/.bash_partials/

	for file in $(ls -a|egrep '^\.[a-zA-Z]');
	do
	     cp $file /tmp/$file
	done
}

function make_vendor() {
	mkdir -p $HOME/.bash/vendor
	cp ../lib/load.sh $HOME/.bash/vendor/load.sh
}

function fetch_fzf_plugin() {
	git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.bash/vendor/fzf
}

function install_fzf_plugin() {
	$HOME/.bash/vendor/fzf/install
}

function dotfiles_install() {
	install_personal_dotfiles \
	&& fetch_fzf_plugin \
	&& install_fzf_plugin
}


dotfiles_install