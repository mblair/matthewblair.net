FROM golang:1.23-alpine
MAINTAINER Matt Blair <me@matthewblair.net>

WORKDIR /app

COPY . .

RUN go build
ENTRYPOINT ["/app/mattyb"]
