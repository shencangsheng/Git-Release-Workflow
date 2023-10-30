FROM alpine:3.15.0

ARG POSTTION

RUN if [[ "${POSTTION}" = "CN" ]] ; then \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories ; \
    fi

RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash git curl

RUN rm -rf /var/cache/apk/* \
    && /bin/bash

COPY changelog-echo.sh /usr/local/bin/changelog-echo
COPY changelog-all-echo.sh /usr/local/bin/changelog-all-echo
COPY changelog-generate.sh /usr/local/bin/changelog-generate
COPY changelog-all-generate.sh /usr/local/bin/changelog-all-generate
COPY post-gitlab-release-13.sh /usr/local/bin/post-gitlab-release-13x
COPY post-gitlab-release-14.sh /usr/local/bin/post-gitlab-release-14x
COPY post-gitlab-release-links-14.sh /usr/local/bin/post-gitlab-release-links-14x
COPY post-gitlab-release-generic-14.sh /usr/local/bin/post-gitlab-release-generic-14x
COPY post-gitlab-release-generic-13.sh /usr/local/bin/post-gitlab-release-generic-13x

RUN chmod -R 755 /usr/local/bin/*

