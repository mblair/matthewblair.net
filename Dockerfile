FROM golang:1.16-alpine
MAINTAINER Matt Blair <me@matthewblair.net>

WORKDIR /app

COPY . .

RUN apk update && apk add git
RUN go build
ENTRYPOINT ["/app/mattyb"]
