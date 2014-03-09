# Run as root
cat /Users/tim/.hosts/head > /tmp/block &&
cat /Users/tim/.hosts/blocking >> /tmp/block &&
cp /etc/hosts/ /etc/hosts.orig &&
mv /tmp/block /etc/hosts
