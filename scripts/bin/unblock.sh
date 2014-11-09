# run as root
cp $HOME/.hosts/head /etc/hosts &&
dscacheutil -flushcache &&
if [ -z "$1" ]
then osascript -e "display notification \"Blocking deactivated.\" with title \"Site blocking\""
fi
