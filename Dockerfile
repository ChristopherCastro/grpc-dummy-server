FROM golang:1.14-alpine AS builder

# Install stuff required to build the artifacts
RUN apk update && apk add --no-cache \
    # SSL CA certificates are required to call HTTPS endpoints
    ca-certificates \
    # Make build automation tool
    make \
    # Git required to operate with the git repository
    git \
    # Zoneinfo for timezones
    tzdata \
    # wget to download stuff
    wget

# A glibc compatibility layer package for Alpine Linux
# protoc is not statically compiled, and adding this package fixes the problem.
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk
RUN apk add glibc-2.29-r0.apk
RUN mkdir -p /opt/app

WORKDIR /opt/app

# This is the 'magic' step that will download all the dependencies that are specified in
# the go.mod and go.sum file.
# Because of how the layer caching system works in Docker, the go mod download
# command will _ only_ be re-run when the go.mod or go.sum file change
# (or when we add another docker instruction this line)
COPY . .
RUN go mod download

RUN make p
RUN make b
FROM alpine:latest

# Copy certificates
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy binaries, one by one, to avoid copying all the other binaries created during the build process
COPY --from=builder /opt/app/bin/server /opt/app/

ENTRYPOINT ["/opt/app/server"]
