FROM golang:1.20-rc
MAINTAINER Matt Blair <me@matthewblair.net>

WORKDIR /app

COPY . .

RUN go build
ENTRYPOINT ["/app/mattyb"]
