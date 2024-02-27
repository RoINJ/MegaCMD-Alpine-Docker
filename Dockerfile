FROM alpine:latest

LABEL maintainer="Ivan Tarasenko <im.ivan.tarasenko@gmail.com>"

RUN apk update \
    && apk add --no-cache alpine-sdk wget autoconf automake libtool readline-dev sqlite-dev curl-dev c-ares-dev libraw-dev libsodium-dev eudev-dev linux-headers dumb-init bash c-ares libmediainfo libpcrecpp libzen gpg libuv-dev crypto++-dev \
# Build MegaCMD
    && git clone https://github.com/meganz/MEGAcmd.git /opt/MEGAcmd \
    && cd /opt/MEGAcmd \
    && git submodule update --init --recursive \
    && sh autogen.sh \
    && ./configure --without-ffmpeg --without-freeimage CFLAGS='-fpermissive' CXXFLAGS='-fpermissive' CPPFLAGS='-fpermissive' CCFLAGS='-fpermissive' \
    && make -j $(nproc) \
    && make install \
    && cd / \
    && find /usr/local/bin -type f  -executable -name 'mega-*' \
        -not -name 'mega-cmd-server' -not -name 'mega-exec' \
        -print0 | xargs -n 1 -0 -I{} sh -c 'if [ -f "{}" ]; then echo "Test: {}"; {} --help > /dev/null || exit 255; fi' \
    && mega-put --help > /dev/null \
    && mega-export --help > /dev/null \
    && rm -rf /opt/MEGAcmd /root/.megaCmd /tmp/* \
# Cleanup
    && apk del make wget alpine-sdk autoconf automake libtool readline-dev sqlite-dev curl-dev c-ares-dev libraw-dev libsodium-dev eudev-dev libuv-dev crypto++-dev linux-headers \
    && apk add --no-cache libsodium libuv crypto++

COPY healthcheck.sh /bin/healthcheck.sh
RUN chmod +x /bin/healthcheck.sh

ENTRYPOINT ["mega-cmd-server"]
HEALTHCHECK --interval=1m --timeout=5s --retries=2 CMD /bin/healthcheck.sh