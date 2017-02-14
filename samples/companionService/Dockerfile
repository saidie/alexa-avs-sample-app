FROM armv7/armhf-debian:jessie

RUN apt-get update && apt-get install -y nodejs npm build-essential && \
    update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

WORKDIR /data

COPY package.json /data

RUN npm install && npm cache clean -f

ARG product_id
ARG serial
ARG client_id
ARG client_secret
ARG hostname
ARG port

COPY . /data

RUN sed -i "s/\$CLIENT_ID/${client_id}/" config.js && \
    sed -i "s/\$CLIENT_SECRET/${client_secret}/" config.js && \
    sed -i "s/\$HOSTNAME/${hostname}/" config.js && \
    sed -i "s/\$PORT/${port}/" config.js && \
    sed -i "s/\$PRODUCT_ID/${product_id}/" config.js && \
    sed -i "s/\$SERIAL/${serial}/" config.js

CMD npm start
