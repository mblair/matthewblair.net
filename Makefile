all: clean fmt install lint docker

clean:
	rm -f matthewblair.net
	go clean -i

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
	# TODO: only run the all target if an image with this Git SHA1 exists
	# check for dirtiness, too
	docker stop $$(docker ps --quiet)
	docker run -p 80:80 -p 443:443 -d -v /var/cache/acme/:/var/cache/acme/ web:$$(git rev-parse --short HEAD)

.PHONY: all freshen fmt install lint vendor docker restart
