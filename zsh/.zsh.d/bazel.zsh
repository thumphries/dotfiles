
select-target() {
  bazel query 'attr(visibility, "//visibility:public", "...")' | fzf
 }

git-root() {
  git rev-parse --show-toplevel
}

# bazel repl with target selection
brz() {
  t=$(select-target "$1")
  br "$t"
}

# access bazel-repl script from anywhere in the repo
alias br='$(git-root)/scripts/bazel/repl'

# run tests with visible errors
alias bt='bazel test --test_output=errors'

# build all the things
alias bbb='bazel build ...'
