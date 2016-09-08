FROM ubuntu:16.04
MAINTAINER Kemal DAG <gkemaldag@gmail.com>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update --fix-missing
RUN apt-get install -y curl
RUN apt-get install -y build-essential libssl-dev

#install gm
RUN apt-get update && apt-get install -y libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev libpng-dev && apt-get clean

RUN apt-get update && apt-get install -y build-essential wget xz-utils graphicsmagick webp


#install supervisord
RUN apt-get update && apt-get install -y python python-setuptools
RUN easy_install supervisor

COPY supervisord.conf /etc/supervisor/supervisord.conf


ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 4.2.6

# Install nvm with node and npm and use 4.2.6 as default
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.6/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

RUN source $NVM_DIR/nvm.sh \
    && nvm install 0.10.46

#set timezone
ENV TZ=Europe/Istanbul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


VOLUME /var/app/code
VOLUME /var/app/logs

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]


