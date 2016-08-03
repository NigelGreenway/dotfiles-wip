for file in $(find -L ./ -type f)
do
    source $file
done