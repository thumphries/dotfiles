# open GUI emacs in foreground, inheriting PATH and ENV
# this is dodgy as hell but whatever
opem () {
  /Applications/Emacs.app/Contents/MacOS/Emacs "$@" &
}