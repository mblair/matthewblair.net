FROM golang:1.8.3-alpine
MAINTAINER Matt Blair <me@matthewblair.net>

WORKDIR /go/src/github.com/mblair/matthewblair.net

COPY . /go/src/github.com/mblair/matthewblair.net

RUN apk update && apk add git
RUN go install github.com/mblair/matthewblair.net
ENTRYPOINT ["/go/bin/matthewblair.net"]
