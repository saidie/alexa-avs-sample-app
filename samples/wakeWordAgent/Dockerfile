FROM armv7/armhf-debian:jessie

RUN apt-get update && apt-get install -y git file wget libasound2-dev libatlas-base-dev make cmake g++ patch

RUN git clone git://git.drogon.net/wiringPi /usr/local/src/wiringpi && \
    cd /usr/local/src/wiringpi && WIRINGPI_SUDO= ./build && rm -rf /usr/local/src/wiringpi

COPY asound.conf /etc/asound.conf

RUN mkdir -p /data/ext/include /data/ext/lib /data/ext/resources

RUN git clone https://github.com/Kitt-AI/snowboy.git /data/snowboy && \
    cd /data/snowboy/examples/C++ && ./install_portaudio.sh && make -j4 && \
    cd /data/snowboy && \
    cp include/snowboy-detect.h \
       examples/C++/portaudio/install/include/portaudio.h \
       examples/C++/portaudio/install/include/pa_ringbuffer.h \
       examples/C++/portaudio/install/include/pa_util.h \
       /data/ext/include/ && \
    cp lib/rpi/libsnowboy-detect.a examples/C++/portaudio/install/lib/libportaudio.a /data/ext/lib/ && \
    cp resources/common.res resources/alexa.umdl /data/ext/resources/ && \
    rm -rf /data/snowboy

RUN git clone https://github.com/Sensory/alexa-rpi.git /data/sensory && \
    cd /data/sensory && \
    ./bin/sdk-license file config/license-key.txt \
        lib/libsnsr.a \
        models/spot-alexa-rpi-20500.snsr \
        models/spot-alexa-rpi-21000.snsr \
        models/spot-alexa-rpi-31000.snsr && \
    cp include/snsr.h /data/ext/include/ && \
    cp lib/libsnsr.a /data/ext/lib/ && \
    cp models/spot-alexa-rpi-31000.snsr /data/ext/resources/spot-alexa-rpi.snsr && \
    rm -rf /data/sensory

COPY src /data/src

WORKDIR /data/src

RUN cmake . && make -j4

CMD ./wakeWordAgent -e sensory
