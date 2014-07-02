$fixer='php-cs-fixer fix --fixers=linefeed,trailing_spaces,unused_use,php_closing_tag,short_tag,return,visibility,braces,phpdoc_params,eof_ending,psr0,controls_spaces,elseif'

function phpCSFixer {
	for f in `find ./src -name *.php`
	do
		$fixer $f
	done
}