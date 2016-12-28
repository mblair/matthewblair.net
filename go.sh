#!/usr/bin/env bash

set -xueo pipefail

go get -u golang.org/x/tools/cmd/goimports
go get -u github.com/shurcooL/markdownfmt
go get -u github.com/govend/govend
go get -u github.com/alecthomas/gometalinter
gometalinter --install --update
