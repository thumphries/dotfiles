PSCDIR=$HOME/bin

# List available psc versions
psc-list-available() {
  echo "Available versions:"
  for ver in $PSCDIR/psc-*; do
    echo "${ver##$PSCDIR/psc-}"
  done
}

# Switch to a specific psc version
psc-switch() {
  if [ -z "$1" ]; then
    echo "USAGE: psc-switch VERSION"
    psc-list-available
    return 1
  fi


  VER_PATH="$PSCDIR/psc-$1"
  if [ -d "$VER_PATH" ]; then
    if [ -z "$PSC_VERSION" ]
      then export PATH=$VER_PATH:$PATH
      else path=($VER_PATH ${(@)path:#*psc*})
    fi
    psc --version
    export PSC_VERSION=$1
  else
    echo "PSC $1 isn't available. Install it with 'psc-install $1'."
    psc-list-available
    return 1
  fi
}

# Install a new version of PSC
# TODO other platforms
psc-install() {
  if [ -z "$1" ]; then
    echo "USAGE: psc-install VERSION"
    echo "Already installed:"
    psc-list-available
    return 1
  fi

  VERSION=$1

  DIST=https://github.com/purescript/purescript/releases/download
  FILE=v$VERSION/macos.tar.gz
  DIR=`pwd`

  cd /tmp \
    && wget "$DIST/$FILE" \
    && tar xvzf macos.tar.gz \
    && mkdir -p "$PSCDIR" \
    && mv /tmp/purescript "$PSCDIR/psc-$VERSION" \
    && psc-switch "$VERSION" \
    && cd "$DIR" \
    || (echo "Failed while installing PSC $VERSION" && cd "$DIR" && return 1)
}

# Cycle PSC versions
p() {
  if [ -n "$1" ]; then psc-switch $1; return $?; fi

  FIRST=
  NEXT=
  for ver in $(psc-list-available | tail -n +2); do
    if [ -z "$FIRST" ]; then FIRST="$ver"; fi
    if [ -z "$PSC_VERSION" ]; then psc-switch $ver; return 0; fi
    if [ -n "$NEXT" ]; then psc-switch $ver; return 0; fi
    if [ $ver = "$PSC_VERSION" ]; then NEXT="true"; continue; fi
  done
  psc-switch $FIRST
}

PSC_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
PSC_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"

# Append to the prompt where helpful
psc_prompt_string() {
  [ -n "$PSC_VERSION" ] && echo "$PSC_PROMPT_PREFIX%{$fg[yellow]%}$PSC_VERSION$PSC_PROMPT_SUFFIX"
}

export RPS1='$(psc_prompt_string)'$RPS1
