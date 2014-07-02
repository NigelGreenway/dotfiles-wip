
host=""
user=""

mysql--search(){ echo "SELECT table_name FROM information_schema.columns WHERE column_name = '$1' AND table_schema = '$2'"|mysql -uroot -p; }