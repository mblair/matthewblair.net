FROM golang:1.23-alpine
LABEL org.opencontainers.image.authors="me@matthewblair.net"

WORKDIR /app

COPY . .

RUN go build
ENTRYPOINT ["/app/mattyb"]
