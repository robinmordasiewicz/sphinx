FROM ubuntu:22.04
LABEL mantainer="Read the Docs <support@readthedocs.com>"
LABEL version="0.0.53"

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

USER root
WORKDIR /

RUN apt-get -y update
RUN apt-get -y install \
      software-properties-common \
      vim apt-utils

RUN apt-get -y install \
      build-essential \
      bzr \
      curl \
      doxygen \
      g++ \
      git-core \
      graphviz-dev \
      libbz2-dev \
      libcairo2-dev \
      libenchant-2-2 \
      libevent-dev \
      libffi-dev \
      libfreetype6 \
      libfreetype6-dev \
      libgraphviz-dev \
      libjpeg8-dev \
      libjpeg-dev \
      liblcms2-dev \
      libmysqlclient-dev \
      libpq-dev \
      libreadline-dev \
      libsqlite3-dev \
      libtiff5-dev \
      libwebp-dev \
      libxml2-dev \
      libxslt1-dev \
      libxslt-dev \
      mercurial \
      pandoc \
      pkg-config \
      postgresql-client \
      subversion \
      zlib1g-dev

# LaTeX -- split to reduce image layer size
RUN apt-get -y install \
    texlive-fonts-extra
RUN apt-get -y install \
    texlive-lang-english \
    texlive-lang-japanese
RUN apt-get -y install \
    texlive-full

# lmodern: extra fonts
# https://github.com/rtfd/readthedocs.org/issues/5494
#
# xindy: is useful to generate non-ascii indexes
# https://github.com/rtfd/readthedocs.org/issues/4454
#
# fonts-noto-cjk-extra
# fonts-hanazono: chinese fonts
# https://github.com/readthedocs/readthedocs.org/issues/6319

RUN apt-get -y install \
    fonts-symbola \
    lmodern \
    latex-cjk-chinese-arphic-bkai00mp \
    latex-cjk-chinese-arphic-gbsn00lp \
    latex-cjk-chinese-arphic-gkai00mp \
    texlive-fonts-recommended \
    fonts-noto-cjk-extra \
    fonts-hanazono \
    xindy

# asdf Python extra requirements
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
RUN apt-get install -y \
    liblzma-dev \
    libncursesw5-dev \
    libssl-dev \
    libxmlsec1-dev \
    llvm \
    make \
    tk-dev \
    wget \
    xz-utils

# asdf nodejs extra requirements
# https://github.com/asdf-vm/asdf-nodejs#linux-debian
RUN apt-get install -y \
    dirmngr \
    gpg

# asdf Golang extra requirements
# https://github.com/kennyp/asdf-golang#linux-debian
RUN apt-get install -y \
    coreutils

# UID and GID from readthedocs/user
# RUN groupadd --gid 1000 ubuntu
# RUN useradd -m --uid 1000 --gid 1000 ubuntu

RUN apt install -y python3-pip python3-sphinx
COPY requirements.txt /tmp/

#RUN pip3 install -r /tmp/requirements.txt --ignore-installed
RUN pip3 install -r /tmp/requirements.txt

# Install terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -

#RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
#    gpg --dearmor | \
#    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

#RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
#    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
#    tee /etc/apt/sources.list.d/hashicorp.list


RUN apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt update
#RUN apt-get -y update
RUN apt install terraform -y
#RUN apt-get install -y terraform

## Install sudo
#RUN apt-get install -y sudo
#RUN adduser ubuntu sudo 
#RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install gosu
RUN apt-get install -y gosu
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# USER ubuntu:ubuntu
# WORKDIR /home/ubuntu
#
## Install asdf
#RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --depth 1 --branch v0.9.0
#RUN echo ". /home/ubuntu/.asdf/asdf.sh" >> /home/ubuntu/.bashrc
#RUN echo ". /home/ubuntu/.asdf/completions/asdf.bash" >> /home/ubuntu/.bashrc

## Activate asdf in current session
#ENV PATH /home/ubuntu/.asdf/shims:/home/ubuntu/.asdf/bin:$PATH

## Install asdf plugins
#RUN asdf plugin add python
#RUN asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
#RUN asdf plugin add rust https://github.com/code-lever/asdf-rust.git
#RUN asdf plugin add golang https://github.com/kennyp/asdf-golang.git

## Create directories for languages installations
#RUN mkdir -p /home/ubuntu/.asdf/installs/python && \
#    mkdir -p /home/ubuntu/.asdf/installs/nodejs && \
#    mkdir -p /home/ubuntu/.asdf/installs/rust && \
#    mkdir -p /home/ubuntu/.asdf/installs/golang

#CMD ["/bin/bash"]

