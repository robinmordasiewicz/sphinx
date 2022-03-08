FROM alpine:latest

ENV APPPATH="/wkdir" NODE_PATH="/usr/lib/node_modules/"
WORKDIR /wkdir

COPY requirements* /tmp/
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
COPY tools/* /usr/local/bin/
ADD vale.tgz /bin

RUN set -x                                      \
    && apk add --update alpine-sdk --no-cache   \
    && apk --update --no-cache add              \
        apk-tools                               \
    && apk add --update py3-pip                 \
    && apk add                                  \
        nodejs                                  \
        musl-dev                                \
        libuv                                   \
        npm                                     \
        yarn                                    \
        ruby                                    \
        bash                                    \
        git                                     \
        graphviz                                \
        python3                                 \
        curl                                    \
        wget                                    \
        sudo                                    \
        vim                                     \
        make                                    \
        py3-yaml                                \
        jpeg-dev                                \
        zlib-dev                                \
        libgcc                                  \
        gcc                                     \
        python3-dev                             \
        libxml2-dev                             \
        libxslt-dev                             \
    && rm -vrf /var/cache/apk/*                                     \
    # && ln -s /usr/bin/python3 /usr/bin/python                       \
    # && ln -s /usr/bin/pip3 /usr/bin/pip                             \
    && npm install -g write-good                                    \
    && npm install -g broken-link-checker                           \
    && npm install -g jsdoc                                         \
    && npm install -g htmlhint                                      \
    && npm install -g sitemap-generator-cli                         \
    && npm install -g rename                                        \
    && pip3 install -r /tmp/requirements.txt --ignore-installed

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/bin/bash" ]

