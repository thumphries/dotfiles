#!/bin/sh
if [ -n "$1" ] && [ "$1" -le "$1" ] # Awful hack to check for integer
then MINS=$(expr $1 \* 60)
     osascript -e "display notification \"Bad sites unblocked for $1 minutes\" with title \"Site blocking\""
     echo "$MINS\t$2"
     unblock.sh quiet && sleep $MINS && block.sh
     #osascript -e "display notification \"Bad sites now blocked.\" with title \"Site blocking\""
else # -eq fails for nonintegers
     echo "$0: Need an integer argument"
fi
