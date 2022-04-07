FROM readthedocs/build:ubuntu-22.04-2022.03.15

USER root

COPY requirements.txt /tmp/
#COPY tools/* /usr/local/bin/
#ADD vale.tgz /bin

RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get --yes update \
    && apt-get --yes install apt-utils \
    && apt-get --yes install docutils-common="0.16+dfsg-2" python3-docutils="0.16+dfsg-2" \
    && apt-mark hold docutils-common \
    && apt-mark hold python3-docutils \
    && pip3 install -r /tmp/requirements.txt --ignore-installed

#    && apt-get --yes upgrade \
#    && apt-get --yes install aptitude \
#    && aptitude -y update \
#    && aptitude -y install npm \
#    && aptitude -y install libnode-dev node-gyp musl-dev libuv1 yarn graphviz sudo python3-pip python3-dev python3-testresources \
#    && pip3 install -r /tmp/requirements.txt --ignore-installed
#    && npm install -g eslint \
#    && npm install -g typescript \
#    && npm install -g broken-link-checker \
#    && npm install -g jsdoc \
#    && npm install -g htmlhint \
#    && npm install -g sitemap-generator-cli \
#    && npm install -g rename

