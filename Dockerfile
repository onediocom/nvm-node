FROM ubuntu:16.04
MAINTAINER Kemal DAG <gkemaldag@gmail.com>

WORKDIR /tmp

ENV GIFSICLE_VERSION 1.88
ENV FFMPEG_VERSION 2.7.2

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update --fix-missing
RUN apt-get install -y curl libssl-dev libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev libpng-dev build-essential wget xz-utils graphicsmagick webp

#install gifsicle
RUN wget -q "http://www.lcdf.org/gifsicle/gifsicle-$GIFSICLE_VERSION.tar.gz" && \
  tar -zxf "gifsicle-$GIFSICLE_VERSION.tar.gz" && cd gifsicle-$GIFSICLE_VERSION && \
  ./configure && make && make install

#install ffmpeg
RUN wget -q "https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz" && \
  tar -xf ffmpeg-release-64bit-static.tar.xz && cd ffmpeg-3.2-64bit-static && \
  mv ffmpeg ffmpeg-10bit ffprobe qt-faststart /usr/local/bin/


#install supervisord
RUN apt-get update && apt-get install -y python python-setuptools
RUN easy_install supervisor

COPY supervisord.conf /etc/supervisor/supervisord.conf


ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 0.10.46

# Install nvm with node and npm and use 4.2.6 as default
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.6/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

#no need to cache v 0.10.46 as it is the default already installed
#RUN source $NVM_DIR/nvm.sh && nvm install 0.10.46

#set timezone
ENV OFFSET="-3"
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN ln -fs /usr/share/zoneinfo/Etc/GMT$OFFSET /etc/localtime

#install lestream
RUN source $NVM_DIR/nvm.sh && npm install -g lestream


CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]


