FROM docker:18.09.9 as static-docker-source

FROM google/cloud-sdk:265.0.0-alpine

# Metadata
LABEL maintainer="Evil Martians <admin@evilmartians.com>"

ARG KUBE_LATEST_VERSION="v1.16.1"
ARG KUBECTL_SHA256="69cfb3eeaa0b77cc4923428855acdfc9ca9786544eeaff9c21913be830869d29"

ARG HELM_VERSION="v2.14.3"
ARG HELM_SHA256="38614a665859c0f01c9c1d84fa9a5027364f936814d1e47839b05327e400bf55"
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
