# Run as root
cat $HOME/.hosts/head > /tmp/block &&
cat $HOME/.hosts/blocking >> /tmp/block &&
cp /etc/hosts /etc/hosts.orig &&
mv /tmp/block /etc/hosts &&
dscacheutil -flushcache &&
if [ -z "$1" ]
then osascript -e "display notification \"Blocking activated.\" with title \"Site blocking\""
fi
