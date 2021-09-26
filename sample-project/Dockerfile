FROM golang:1.15 AS builder
WORKDIR /build/
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -o hello-world .

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /build/hello-world .
ENTRYPOINT ["./hello-world"]
