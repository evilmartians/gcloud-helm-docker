FROM docker:19.03.8 as static-docker-source

FROM google/cloud-sdk:285.0.1-alpine

# Metadata
LABEL maintainer="Evil Martians <admin@evilmartians.com>"

ARG KUBE_LATEST_VERSION="v1.16.7"
ARG KUBECTL_SHA256="c31ca51b526489cd929be71fc1dc9c3cc24b6df5641b3505b467bac51862047d"

ARG HELM_VERSION="v3.1.2"
ARG HELM_SHA256="e6be589df85076108c33e12e60cfb85dcd82c5d756a6f6ebc8de0ee505c9fd4c"
ARG HELM_ARCHIVE="helm-${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_URL="https://get.helm.sh/${HELM_ARCHIVE}"

COPY --from=static-docker-source /usr/local/bin/docker /usr/local/bin/docker

RUN apk add --update ca-certificates \
    && apk add --update -t deps curl \
    && apk add bash \
    && curl -L https://storage.googleapis.com/kubernetes-release/release/$KUBE_LATEST_VERSION/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && echo "${KUBECTL_SHA256}  /usr/local/bin/kubectl" | sha256sum -c \
    && chmod +x /usr/local/bin/kubectl \
    && curl -L "${HELM_URL}" -o "/tmp/${HELM_ARCHIVE}" \
    && echo "${HELM_SHA256}  /tmp/${HELM_ARCHIVE}" | sha256sum -c \
    && tar -zxvf /tmp/${HELM_ARCHIVE} -C /tmp \
    && mv /tmp/linux-amd64/helm /usr/local/bin/helm \
    && apk del --purge deps \
    && rm /var/cache/apk/* \
    && rm -rf /tmp/*

WORKDIR /root

CMD ["/bin/sh"]
