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