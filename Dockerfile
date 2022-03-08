FROM readthedocs/build:ubuntu-20.04-2022.02.16

COPY requirements* /tmp/
COPY tools/* /usr/local/bin/
ADD vale.tgz /bin

USER root

RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get --yes update
RUN apt-get --yes upgrade

RUN apt --yes install aptitude
RUN aptitude -y install libnode-dev                        
RUN aptitude -y install libnode64
RUN aptitude -y install node-gyp
RUN aptitude -y install npm
RUN aptitude -y install nodejs

#RUN apt-get upgrade --yes nodejs

#RUN apt-get -y install                          \
RUN aptitude -y install                          \
        python3-pip                             \
        musl-dev                                \
        libuv1                                  \
        npm                                     \
        yarn                                    \
        graphviz                                \
        sudo                                    \
        python3-dev

#    # && ln -s /usr/bin/python3 /usr/bin/python                       \
#    # && ln -s /usr/bin/pip3 /usr/bin/pip                             \

#RUN npm install -g eslint                                       \
#    && npm install -g typescript                                       \
#    && npm install -g write-good                                           \
#    && npm install -g broken-link-checker                           \
#    && npm install -g jsdoc                                         \
#    && npm install -g htmlhint                                      \
#    && npm install -g sitemap-generator-cli                         \
#    && npm install -g rename

RUN npm install -g eslint \
    && npm install -g typescript \
    && npm install -g broken-link-checker \
    && npm install -g jsdoc \
    && npm install -g htmlhint \
    && npm install -g sitemap-generator-cli \
    && npm install -g rename

RUN pip3 install -r /tmp/requirements.txt --ignore-installed

#USER docs

#ENTRYPOINT [ "/entrypoint.sh" ]

