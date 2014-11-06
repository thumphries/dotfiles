# run as root
cp $HOME/.hosts/head /etc/hosts &&
dscacheutil -flushcache &&
osascript -e "display notification \"Blocking deactivated.\" with title \"Site blocking\""
