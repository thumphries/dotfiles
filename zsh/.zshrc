ZSHDIR=$HOME/.zsh.d

# Load any modules in .zsh.d
source $ZSHDIR/path
source $ZSHDIR/prompt
for f in $HOME/.zsh.d/*.zsh; do source $f; done

# Load untracked .zshrc.local if it exists
if [ -e $HOME/.zshrc.local ]; then source $HOME/.zshrc.local; fi

# Set useful global options
REPORTTIME=10

# allow comments in interactive mode
setopt interactivecomments

# FIX get the rest of this crap into appropriate files / get rid of em
export MUSIC_DIR="/Volumes/Music/"
export EDITOR="emacsclient -t"

alias work="tmux attach -t prog || tmux"
