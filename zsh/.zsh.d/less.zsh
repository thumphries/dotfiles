# enable syntax highlighting when source-highlight is installed
# (brew install source-highlight)
if which src-hilite-lesspipe.sh; then
  LESSOPEN="| src-hilite-lesspipe.sh %s"
  LESS=' -R '
fi
export LESSOPEN
export LESS
