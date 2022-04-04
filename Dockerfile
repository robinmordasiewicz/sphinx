FROM readthedocs/build:ubuntu-20.04-2022.02.16

USER root

ADD VERSION .

COPY requirements* /tmp/
COPY tools/* /usr/local/bin/
ADD vale.tgz /bin

RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get --yes update \
    && apt-get --yes upgrade \
    && apt --yes install aptitude \
    && aptitude -y install libnode-dev \
    && aptitude -y install libnode64 \
    && aptitude -y install node-gyp \
    && aptitude -y install npm \
    && aptitude -y install nodejs \
    && aptitude -y install python3-pip \
    && aptitude -y install musl-dev \
    && aptitude -y install libuv1 \
    && aptitude -y install yarn \
    && aptitude -y install graphviz \
    && aptitude -y install sudo \
    && aptitude -y install python3-dev \
    && npm install -g eslint \
    && npm install -g typescript \
    && npm install -g broken-link-checker \
    && npm install -g jsdoc \
    && npm install -g htmlhint \
    && npm install -g sitemap-generator-cli \
    && npm install -g rename

RUN pip3 install -r /tmp/requirements.txt --ignore-installed

