file="/sys/class/backlight/"${YOUR_GPU_HERE}"/brightness"
echo $(($(cat $file)${1}${2})) > $file
