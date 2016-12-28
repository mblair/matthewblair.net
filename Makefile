all: setup fmt install lint docker

setup:
	./go.sh

fmt:
	goimports -w *.go
	markdownfmt -w *.md

install:
	go install github.com/mblair/matthewblair.net

lint:
	gometalinter --errors --deadline=60s .

vendor:
	govend --prune -v -l

docker:
	docker build -t web:$$(git rev-parse --short HEAD) .

restart:
	docker stop $$(docker ps --quiet)
	docker run -p 80 -v /var/cache/acme/:/var/cache/acme/ web:$$(git rev-parse --short HEAD)

.PHONY: all fmt lint vendor docker restart
