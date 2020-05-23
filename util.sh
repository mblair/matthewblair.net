#!/usr/bin/env bash

set -xueo pipefail

freshen() {
	go get -u golang.org/x/tools/cmd/goimports
	go get -u mvdan.cc/sh/cmd/shfmt
	go get -u github.com/shurcooL/markdownfmt
}

if [[ "$#" -gt 0 ]]; then
	while [[ "$#" -gt 0 ]]; do
		case "$1" in
		--freshen)
			freshen
			shift
			;;
		esac
	done
fi
