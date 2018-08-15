NODEDIR=$HOME/bin

# List available node versions
node-list-available() {
  echo "Available versions:"
  for ver in $NODEDIR/node-*; do
    echo "${ver##$NODEDIR/node-}"
  done
}

# Switch to a specific node version
node-switch() {
  if [ -z "$1" ]; then
    echo "USAGE: node-switch VERSION"
    node-list-available
    return 1
  fi


  VER_PATH="$NODEDIR/node-$1/bin"
  if [ -d "$VER_PATH" ]; then
    if [ -z "$NODE_VERSION" ]
      then export PATH=$VER_PATH:$PATH
      else path=($VER_PATH ${(@)path:#*node*})
    fi
    node --version
    export NODE_VERSION=$1
  else
    echo "NODE $1 isn't available. Install it with 'node-install $1'."
    node-list-available
    return 1
  fi
}

# Cycle NODE versions
n() {
  if [ -n "$1" ]; then node-switch $1; return $?; fi

  FIRST=
  NEXT=
  for ver in $(node-list-available | tail -n +2); do
    if [ -z "$FIRST" ]; then FIRST="$ver"; fi
    if [ -z "$NODE_VERSION" ]; then node-switch $ver; return 0; fi
    if [ -n "$NEXT" ]; then node-switch $ver; return 0; fi
    if [ $ver = "$NODE_VERSION" ]; then NEXT="true"; continue; fi
  done
  node-switch $FIRST
}

NODE_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
NODE_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"

# Append to the prompt where helpful
node_prompt_string() {
  [ -n "$NODE_VERSION" ] && echo "$NODE_PROMPT_PREFIX%{$fg[yellow]%}$NODE_VERSION$NODE_PROMPT_SUFFIX"
}

export RPS1='$(node_prompt_string)'$RPS1
