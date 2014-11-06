# run as root
cp $HOME/.hosts/head /etc/hosts &&
osascript -e "display notification \"Blocking deactivated.\" with title \"Site blocking\""
