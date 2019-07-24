
## Dodgy git aliases

# fixup commit with autostage
alias fixup="git commit -a --fixup=HEAD^"

# pull every submodule up to origin/master - not subtle
alias bump="git submodule foreach '(git checkout master; git pull)&'"

# match origin/master
alias gom="git fetch origin && git checkout origin/master && git submodule sync && git submodule update"

# checkout origin/master
alias gcom="git checkout origin/master"

# rebase origin/master
alias grom="git rebase origin/master"

# print root of working tree
git-root() {
  git rev-parse --show-toplevel
}

# cd to root of working tree
alias r='cd $(git-root)'

# prune all merged branches
alias prune-merged-branches="git branch --merged | grep -e "topic/" | xargs git branch -d"

# submodule dance
alias gss="git submodule sync && git submodule update"

# fetch origin
alias gfo="git fetch origin --prune"

# fast-forward to remote HEAD
alias gff='git merge --ff-only $(git for-each-ref --format="%(upstream:short)" $(git symbolic-ref -q HEAD))'

# safe force-push
alias gfp='git push --force-with-lease origin "$(git rev-parse --abbrev-ref HEAD)"'

# interactive rebase up to common ancestor
alias grb='git rebase -i "$(git merge-base origin/master HEAD)"'

# clean up ignored files
alias gcx='git clean -x'

# tig shorthand
alias ts="tig status"

# list all branches, sorted by most recent commit
alias gb="git for-each-ref --sort=-committerdate --format='%(committerdate:short) %(refname)' refs/heads refs/remotes"

# list all local branches, sorted by most recent commit
alias gbs="git for-each-ref --sort=-committerdate --format='%(committerdate:short) %(refname)' refs/heads"

# remove a submodule
git-remove-submodule() {
  if [ -z "$1" ]; then
    echo "USAGE: git-remove-submodule path/to/submodule"
    echo "Available submodules:"
    git submodule
    return 1
  fi
  set +eux
  GIT_ROOT=$(git-root)
  git submodule deinit -f -- "$1"
  rm -rf "${GIT_ROOT}/.git/modules/$1"
  git rm -f "$1"
  echo "Removed submodule $1"
}

# fuzzy finders
switch-branch() {
  S_BRANCH=$(git for-each-ref --sort=-committerdate --format="%(refname)" refs/heads | fzf --preview="git log {}")
  if [ ! -z "S_BRANCH" ]; then
    R_BRANCH=$(echo $S_BRANCH | sed -e 's@refs/heads/@@')
    if [ ! -z "$R_BRANCH" ]; then
      git checkout $R_BRANCH
#      print -z "git checkout $R_BRANCH"
    fi
  fi
}

switch-branch-remote() {
  S_BRANCH=$(git for-each-ref --sort=-committerdate --format="%(refname)" refs/remotes | fzf --preview="git log {}")
  if [ ! -z "S_BRANCH" ]; then
    R_BRANCH=$(echo $S_BRANCH | sed -e 's@refs/remotes/origin/@@')
    if [ ! -z "$R_BRANCH" ]; then
      git checkout $R_BRANCH
#      print -z "git checkout $R_BRANCH"
    fi
  fi
}

alias gs="switch-branch"
alias gsr="switch-branch-remote"

# Git rprompt
# From http://blog.joshdick.net/2012/12/30/my_git_prompt_for_zsh.html
# Adapted from code found at <https://gist.github.com/1712320>.

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}●%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"

# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
parse_git_state() {

  # Compose this value via multiple conditional appends.
  local GIT_STATE=""

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi

  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi

  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi

}

# If inside a Git repository, print its branch and state
git_prompt_string() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
}

# Set the right-hand prompt
RPS1='$(git_prompt_string)'$RPS1
