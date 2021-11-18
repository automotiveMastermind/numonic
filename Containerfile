ARG FROM_REPO=ubuntu
ARG FROM_TAG=latest
FROM ${FROM_REPO}:${FROM_TAG}

ARG NUMONIC_SHELL=bash

WORKDIR /repo
COPY . .

VOLUME /var/lib/containers
VOLUME /home/numonic/.local/share/containers

RUN ./hack/pre.sh numonic
USER numonic

ENV NUMONIC_CONTAINER="true" \
    _CONTAINERS_USERNS_CONFIGURED=""

RUN set -ex; \
    ./install.sh ${NUMONIC_SHELL}; \
    ./hack/clean.sh --force;

WORKDIR /home/numonic
COPY entrypoint.sh /home/numonic/.local/bin/entrypoint
ENTRYPOINT [ "/home/numonic/.local/bin/entrypoint" ]
