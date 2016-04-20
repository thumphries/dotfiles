# Autojump
AUTOJUMP=`brew --prefix`/etc/autojump.sh
if [ -f $AUTOJUMP ]; then
  . $AUTOJUMP
fi
