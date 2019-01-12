# $1 = origin folder
# $2 = file name/pattern
# $3 = destination folder
find "$1" -name $2 -exec cp {} "$3" \;
