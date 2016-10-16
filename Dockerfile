
FROM alpine:3.4

MAINTAINER Robert Weclawski <robert.weclawski@mykolab.com>
ENV XO_SERVER_VERSION=5.2.6 \
    XO_WEB_VERSION=5.2.5 \
    N_VERSION=2.1.0

RUN \
    apk update && \
    apk add nodejs curl wget bash git python gcc g++ make && \
    mkdir -p /opt/xo && \
    adduser -S xo_app -h /opt/xo && \
    chown -R xo_app:nogroup /opt/xo && \
    cd /opt/xo && \
    wget -O xo-server.tgz  https://github.com/vatesfr/xo-server/archive/v$XO_SERVER_VERSION.tar.gz && \
    wget -O xo-web.tgz https://github.com/vatesfr/xo-web/archive/v$XO_WEB_VERSION.tar.gz && \
    tar xvzf xo-server.tgz && \
    tar xvzf xo-web.tgz && \
    mv xo-server-$XO_SERVER_VERSION server && \
    mv xo-web-$XO_WEB_VERSION web && \
    rm -f /opt/xo/*.tgz
RUN \
    cd /opt/xo/server && \
    npm install && \
    npm run build && \
    cd /opt/xo/web/ \
    && npm install \
    && npm run build && \
    cd /opt/xo

RUN \
    mkdir -p /var/lib/xo-server/data && \
    chown xo_app:nogroup -R /var/lib/xo-server/ && \
    chown -R xo_app:nogroup /opt/xo/

RUN \
    npm install --global xo-server-backup-reports forever && \
    apk del gcc g++ make

COPY xo-server.yaml /etc/xo-server/config.yaml

COPY main.css /opt/app/xo-web/dist/assets/main.css
RUN \
    sed -i 's/images\/logo_small.png/assets\/logo.png/' /opt/xo/server/signin.pug && \
    sed -i 's/styles\/main.css/assets\/main.css/' /opt/xo/server/signin.pug && \
    sed -i 's/favicon|fontawesome/favicon|fontawesome|assets/' /opt/xo/server/dist/index.js
USER xo_app

WORKDIR /opt/xo
CMD [ "forever", "/opt/xo/server/bin/xo-server" ]
