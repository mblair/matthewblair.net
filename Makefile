all: fmt lint docker

fmt:
	goimports -w *.go
	markdownfmt -w *.md

lint:
	gometalinter --deadline=60s .

vendor:
	 govend --prune -v -l

docker:
	docker build -t web:$$(git rev-parse --short HEAD) .

run:
	docker run web:$$(git rev-parse --short HEAD)

.PHONY: all fmt lint vendor docker run
