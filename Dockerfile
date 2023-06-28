FROM golang:1.21-rc-alpine
MAINTAINER Matt Blair <me@matthewblair.net>

WORKDIR /app

COPY . .

RUN go build
ENTRYPOINT ["/app/mattyb"]
