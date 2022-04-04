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
    && apt-get --yes install aptitude apt-utils python3-docutils=0.17.1 \
    && aptitude -y update \
    && aptitude -y install libnode-dev libnode64 node-gyp npm nodejs musl-dev libuv1 yarn graphviz sudo python3-pip python3-dev python3-testresources \
    && npm install -g eslint \
    && npm install -g typescript \
    && npm install -g broken-link-checker \
    && npm install -g jsdoc \
    && npm install -g htmlhint \
    && npm install -g sitemap-generator-cli \
    && npm install -g rename

RUN pip3 install -r /tmp/requirements.txt --ignore-installed

