# Multi-stage build setup (https://docs.docker.com/develop/develop-images/multistage-build/)

# Stage 1 (to create a "build" image, ~850MB)
FROM golang:1.10.1 AS builder
RUN go version

COPY . /go/src/github.com/miguno/golang-docker-build-tutorial/
WORKDIR /go/src/github.com/miguno/golang-docker-build-tutorial/
RUN set -x && \
    go get github.com/golang/dep/cmd/dep && \
    dep ensure -v
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o app .
FROM scratch
WORKDIR /root/
COPY --from=builder /go/src/github.com/miguno/golang-docker-build-tutorial/app .
HEALTHCHECK CMD curl --fail http://localhost:8123 || exit 1
EXPOSE 8123
ENTRYPOINT ["./app"]
