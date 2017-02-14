FROM armv7/armhf-debian:jessie

# ref: http://linuxg.net/how-to-install-the-oracle-java-8-on-debian-wheezy-and-debian-jessie-via-repository/
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list && \
    ( apt-key adv --keyserver pgp.mit.edu --recv-keys EEA14886 || \
      apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 )

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get update && apt-get install -y oracle-java8-installer oracle-java8-set-default maven vlc vlc-nox vlc-data

COPY asound.conf /etc/asound.conf

ARG product_id
ARG serial
ARG hostname
ARG port

COPY . /data

WORKDIR /data

RUN sed -i "s/\$HOSTNAME/${hostname}/" config.json && \
    sed -i "s/\$PORT/${port}/" config.json && \
    sed -i "s/\$PRODUCT_ID/${product_id}/" config.json && \
    sed -i "s/\$SERIAL/${serial}/" config.json

RUN mvn install

CMD mvn exec:exec
