FROM golang:1.19-alpine
MAINTAINER Matt Blair <me@matthewblair.net>

WORKDIR /app

COPY . .

RUN apk update && apk add git gcc
RUN go build
ENTRYPOINT ["/app/mattyb"]
