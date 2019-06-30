FROM docker:18.09.7 as static-docker-source

FROM google/cloud-sdk:252.0.0-alpine

# Metadata
LABEL maintainer="Evil Martians <admin@evilmartians.com>"

ARG KUBE_LATEST_VERSION="v1.15.0"
ARG KUBECTL_SHA256="ecec7fe4ffa03018ff00f14e228442af5c2284e57771e4916b977c20ba4e5b39"

ARG HELM_VERSION="v2.14.1"
ARG HELM_SHA256="804f745e6884435ef1343f4de8940f9db64f935cd9a55ad3d9153d064b7f5896"
ARG HELM_ARCHIVE="helm-${HELM_VERSION}-linux-amd64.tar.gz"

COPY --from=static-docker-source /usr/local/bin/docker /usr/local/bin/docker

RUN apk add --update ca-certificates \
    && apk add --update -t deps curl \
    && apk add bash \
    && curl -L https://storage.googleapis.com/kubernetes-release/release/$KUBE_LATEST_VERSION/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && echo "${KUBECTL_SHA256}  /usr/local/bin/kubectl" | sha256sum -c \
    && chmod +x /usr/local/bin/kubectl \
    && curl -L "https://storage.googleapis.com/kubernetes-helm/${HELM_ARCHIVE}" -o "/tmp/${HELM_ARCHIVE}" \
    && echo "${HELM_SHA256}  /tmp/${HELM_ARCHIVE}" | sha256sum -c \
    && tar -zxvf /tmp/${HELM_ARCHIVE} -C /tmp \
    && mv /tmp/linux-amd64/helm /usr/local/bin/helm \
    && apk del --purge deps \
    && rm /var/cache/apk/* \
    && rm -rf /tmp/*

WORKDIR /root

CMD ["/bin/sh"]
