ZSHDIR=$HOME/.zsh.d

source $ZSHDIR/path
source $ZSHDIR/prompt
for f in $HOME/.zsh.d/*.zsh; do source $f; done


# FIX get the rest of this crap into appropriate files / get rid of em


export MUSIC_DIR="/Volumes/Music/"
export EDITOR="/usr/local/bin/emacsclient -t"

alias work="tmux attach -t prog || tmux"
