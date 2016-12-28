#!/usr/bin/env bash

set -xueo pipefail

freshen() {
  go get -u golang.org/x/tools/cmd/goimports
  go get -u github.com/mvdan/sh/cmd/shfmt
  go get -u github.com/shurcooL/markdownfmt
  go get -u github.com/govend/govend
  go get -u github.com/alecthomas/gometalinter
  gometalinter --install --update
}

if [[ "$#" -gt 0 ]]; then
	while [[ "$#" -gt 0 ]]; do
		case "$1" in
      --freshen)
      freshen
      ;;
    esac
  done
fi
