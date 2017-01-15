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
	css-beautify -r *.css
	html-beautify -r *.html

install:
	go install github.com/mblair/matthewblair.net

lint:
	gometalinter --errors --deadline=60s .

vendor:
	govend --prune -v -l

docker:
	docker build -t web:$$(git rev-parse --short HEAD) .

stop:
	docker stop $$(docker ps --quiet)

run: docker
	docker run -p 80:80 -p 443:443 -v /var/cache/acme:/var/cache/acme -d --restart=always web:$$(git rev-parse --short HEAD)

restart: all stop run

.PHONY: all freshen fmt install lint vendor docker stop run restart
