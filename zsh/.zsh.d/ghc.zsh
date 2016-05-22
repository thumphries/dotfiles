GHCDIR=$HOME/bin

# List available GHC versions
ghc-list-available() {
  echo "Available versions:"
  for ver in $GHCDIR/ghc-*; do
    echo "${ver##$GHCDIR/ghc-}"
  done
}

# Switch to a specific GHC version
ghc-switch() {
  if [ -z "$1" ]; then
    echo "USAGE: ghc-switch VERSION"
    ghc-list-available
    return 1
  fi


  VER_PATH="$GHCDIR/ghc-$1"
  if [ -d "$VER_PATH" ]; then
    if [ -z "$GHC_VERSION" ]
      then export PATH=$VER_PATH/bin:$PATH
      else export path=($VER_PATH/bin ${(@)path:#*ghc*})
    fi
    ghc --version
    export GHC_VERSION=$1
  else
    echo "GHC $1 isn't available. Install it with 'ghc-install $1'."
    ghc-list-available
    return 1
  fi
}

# Install a new version of GHC
ghc-install() {
  if [ -z "$1" ]; then
    echo "USAGE: ghc-install VERSION"
    echo "Already installed:"
    ghc-list-available
    return 1
  fi

  VERSION=$1
  DIST=https://www.haskell.org/ghc/dist/
  FILEX=ghc-$VERSION-x86_64-apple-darwin.tar.xz
  FILEB=ghc-$VERSION-x86_64-apple-darwin.tar.bz2
  DIR=`pwd`

  cd /tmp \
    && (wget $DIST/$VERSION/$FILEX || wget $DIST/$VERSION/$FILEB)  \
    && tar xf ghc-$VERSION-*.tar.* \
    && cd ghc-$VERSION \
    && ./configure --prefix=$GHCDIR/ghc-$VERSION \
    && make install \
    && ghc-switch $VERSION \
    && cd $DIR \
    || (echo "Failed while installing GHC $VERSION" && cd $DIR && return 1)

}

# Cycle GHC versions
g() {
  if [ -n "$1" ]; then ghc-switch $1; return $?; fi

  FIRST=
  NEXT=
  for ver in $(ghc-list-available | tail -n +2); do
    if [ -z "$FIRST" ]; then FIRST="$ver"; fi
    if [ -z "$GHC_VERSION" ]; then ghc-switch $ver; return 0; fi
    if [ -n "$NEXT" ]; then ghc-switch $ver; return 0; fi
    if [ $ver = "$GHC_VERSION" ]; then NEXT="true"; continue; fi
  done
  ghc-switch $FIRST
}

GHC_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GHC_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"

# Append to the prompt where helpful
ghc_prompt_string() {
  [ -n "$GHC_VERSION" ] && echo "$GHC_PROMPT_PREFIX%{$fg[yellow]%}$GHC_VERSION$GHC_PROMPT_SUFFIX"
}

export RPS1='$(ghc_prompt_string)'$RPS1
export PATH="$HOME/.cabal/bin:$PATH"
