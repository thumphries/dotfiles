{ pkgs }:
pkgs.fetchgit {
  url = "https://github.com/thumphries/xalternative";
  rev = "3b70fe7cc7c2ee0f0b8c7a3072b5c512e90bd54d";
  sha256 = "1zcc71alicrxnhjd2qn48f7b7w1gbbdmq4kw30fsxnl71gcp5c2q";
  fetchSubmodules = true;
}
