FROM golang:1.22-rc-alpine
MAINTAINER Matt Blair <me@matthewblair.net>

WORKDIR /app

COPY . .

RUN go build
ENTRYPOINT ["/app/mattyb"]
