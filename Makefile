all: freshen fmt install lint docker

freshen:
	./util.sh --freshen

fmt:
	goimports -w *.go
	shfmt -w *.sh
	markdownfmt -w *.md

install:
	go install github.com/mblair/matthewblair.net

lint:
	gometalinter --errors --deadline=60s .

vendor:
	govend --prune -v -l

docker:
	docker build -t web:$$(git rev-parse --short HEAD) .

restart: all
	docker stop $$(docker ps --quiet)
	docker run -p 80:80 -p 443:443 -d -v /var/cache/acme/:/var/cache/acme/ web:$$(git rev-parse --short HEAD)

.PHONY: all freshen fmt install lint vendor docker restart
