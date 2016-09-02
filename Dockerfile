FROM ubuntu:16.04
MAINTAINER Kemal DAG <gkemaldag@gmail.com>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update --fix-missing
RUN apt-get install -y curl
RUN apt-get install -y build-essential libssl-dev


#install supervisord
RUN apt-get update && apt-get install -y python python-setuptools
RUN easy_install supervisor


ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 4.2.6

# Install nvm with node and npm and use 4.2.6 as default
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.6/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
