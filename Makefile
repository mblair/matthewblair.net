all: clean fmt build docker

clean:
	rm -f mattyb
	go clean -i

freshen:
	./util.sh --freshen

fmt:
	# TODO: guard this
	#gsed -i'' -e's/[[:space:]]*$$//g' Makefile
	goimports -w *.go
	shfmt -w *.sh
	markdownfmt -w *.md
	prettier --write *.css
	html-beautify -r *.html

build:
	go install

vendor:
	dep ensure

vendorupdate:
	dep ensure -update

docker:
	docker build -t web:$$(git rev-parse --short HEAD) .

stop:
	docker stop $$(docker ps --quiet)

run: docker
	docker run -p 80:80 -p 443:443 -v /var/cache/acme:/var/cache/acme -e GODEBUG=tls13=1 -d --restart=always web:$$(git rev-parse --short HEAD)

restart: docker stop run

.PHONY: all freshen fmt install vendor docker stop run restart
