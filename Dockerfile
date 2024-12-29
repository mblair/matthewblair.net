FROM golang:1.24-rc
LABEL org.opencontainers.image.authors="me@matthewblair.net"

WORKDIR /app

COPY . .

RUN go build
ENTRYPOINT ["/app/mattyb"]
