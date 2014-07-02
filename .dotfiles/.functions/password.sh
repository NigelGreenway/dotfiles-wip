pwdsha1() {
	read -s -p 'Password:'
	echo ''
	echo -n '"$1"' | openssl sha1
}

pwdmd5() {
	read -s -p 'Password:'
	echo ''
	echo -n '"$1"' | md5
}