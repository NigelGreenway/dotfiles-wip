## Apache shortcuts
alias apache-s="sudo apachectl start"
alias apache-r="sudo apachectl restart"
alias apache-rg="sudo apachectl graceful"
alias apache-e="sudo apachectl stop"
alias apache-eg="sudo apachectl graceful-stop"
alias apache-t="sudo apachectl configtest"

## Nginx shortcuts
alias nginx-s="/usr/bin/nginx"
alias nginx-r="/usr/bin/nginx -s stop && nginx-s"
alias nginx-e="nginx-s -t"