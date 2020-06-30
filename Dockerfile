# Base
#FROM alpine:latest AS base
# Use Docker Buildx
FROM --platform=$TARGETPLATFORM alpine:latest AS base
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
RUN set -ex; \
    apk add --no-cache curl wget && \
    cd /tmp && \
    wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-${VERSION:-7.6.2}-linux-x86_64.tar.gz && \
    tar -xzf metricbeat-${VERSION:-7.6.2}-linux-x86_64.tar.gz && \
    rm -rf metricbeat-${VERSION:-7.6.2}-linux-x86_64/metricbeat

# Builder
#FROM golang:latest AS builder
# Use Docker Buildx
FROM --platform=$TARGETPLATFORM golang:latest AS builder
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG GO_ARCH

#ENV CGO_ENABLED=0 GOOS=linux GOARCH=${GO_ARCH:-amd64}

# GO
#RUN go get -x github.com/elastic/beats; exit 0
RUN go get github.com/elastic/beats; exit 0

WORKDIR $GOPATH/src/github.com/elastic/beats

#ENV CGO_ENABLED=0 GOOS=linux GOARCH=${GO_ARCH:-arm64}
RUN git fetch && \
    git checkout tags/v${VERSION:-7.6.2} && \
    cd metricbeat && \
    make
    #CGO_ENABLED=0 GOOS=linux GOARCH=${GO_ARCH:-arm64} make

# GIT
#RUN set -ex; \
#    mkdir -p $GOPATH/src/github.com/elastic \
#    git -C $GOPATH/src/github.com/elastic clone --depth 1 --single-branch --branch v${VERSION:-7.6.2} https://github.com/elastic/beats

#WORKDIR $GOPATH/src/github.com/elastic/beats

#ENV CGO_ENABLED=0 GOOS=linux GOARCH=${GO_ARCH:-arm64}
#RUN cd metricbeat && \
#    make
    #CGO_ENABLED=0 GOOS=linux GOARCH=${GO_ARCH:-arm64} make

# Prod 
#FROM ubuntu:focal
# Use Docker Buildx
FROM --platform=$TARGETPLATFORM ubuntu:focal
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION

ENV ELASTIC_CONTAINER true
ENV PATH=/usr/share/metricbeat:$PATH

COPY --from=base /tmp/metricbeat-${VERSION:-7.6.2}-linux-x86_64/ /usr/share/metricbeat
COPY --from=builder /go/src/github.com/elastic/beats/metricbeat/metricbeat /usr/share/metricbeat
COPY docker-entrypoint /usr/local/bin/

RUN groupadd --gid 1000 metricbeat && \
    useradd -M --uid 1000 --gid 1000 --home /usr/share/metricbeat metricbeat

WORKDIR /usr/share/metricbeat
RUN mkdir data logs && \
    chown -R root:metricbeat . && \
    find /usr/share/metricbeat -type d -exec chmod 0750 {} \; && \
    find /usr/share/metricbeat -type f -exec chmod 0640 {} \; && \
    chmod 0750 /usr/local/bin/docker-entrypoint && \
    chmod 0750 /usr/share/metricbeat/metricbeat && \
    chmod 0770 modules.d && \
    chmod 0770 data logs modules.d

#USER 1000
USER metricbeat

LABEL org.label-schema.schema-version="1.0" \
  org.label-schema.vendor="Elastic" \
  org.label-schema.name="metricbeat" \
  org.label-schema.version="${VERSION}" \
  org.label-schema.url="https://www.elastic.co/products/beats/metricbeat" \
  org.label-schema.vcs-url="https://github.com/elastic/beats-docker" \
  license="Elastic License"

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
CMD ["-e"]
