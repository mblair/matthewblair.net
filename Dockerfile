FROM golang:1.18-rc-alpine
MAINTAINER Matt Blair <me@matthewblair.net>

WORKDIR /app

COPY . .

RUN apk update && apk add git gcc
RUN go build
ENTRYPOINT ["/app/mattyb"]
