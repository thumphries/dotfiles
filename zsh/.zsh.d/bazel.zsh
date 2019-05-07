
select-target() {
  bazel query 'attr(visibility, "//visibility:public", "...")' | fzf
 }

git-root() {
  git rev-parse --show-toplevel
}


# access bazel-repl script from anywhere in the repo
alias br='$(git-root)/scripts/bazel/repl'
alias bd='$(git-root)/scripts/bazel/ghcid'

# bazel repl with target selection
brz() {
  t=$(select-target "$1")
  br "$t"
}

brr() {
  t=$(select-target "$1")
  bazel run "$t"
}

brd() {
  t=$(select-target "$1")
  bd "$t"
}

# run tests with visible errors
alias bt='bazel test --test_output=errors'

# build the thing
alias bb='bazel build'

# build all the things
alias bbb='bb ...'

bbz() {
  t=$(select-target "$1")
  bb "$t"
}
