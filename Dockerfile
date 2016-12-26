FROM golang:1.8-alpine
MAINTAINER Matt Blair <me@matthewblair.net>

WORKDIR /go/src/github.com/mblair/matthewblair.net

COPY . /go/src/github.com/mblair/matthewblair.net

RUN apk update && apk add git
# TODO: vendor...
RUN go get -u golang.org/x/crypto/acme/autocert
RUN go install github.com/mblair/matthewblair.net
ENTRYPOINT ["/go/bin/matthewblair.net"]
EXPOSE 80 443
