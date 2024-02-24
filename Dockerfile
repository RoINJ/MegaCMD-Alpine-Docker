FROM alpine:3.15

ENV CRYPTOPP_VERSION 8.6.0

RUN apk update \
    && apk add --no-cache alpine-sdk wget autoconf automake libtool readline-dev sqlite-dev curl-dev c-ares-dev libraw-dev libsodium-dev eudev-dev linux-headers dumb-init bash c-ares libmediainfo libpcrecpp libzen gpg libuv-dev \
# Build crypto++
    && mkdir -p /opt/cryptopp \
    && cd /opt/cryptopp \
    && wget -O cryptopp.zip https://www.cryptopp.com/cryptopp${CRYPTOPP_VERSION//./}.zip \
    && unzip cryptopp.zip -d . \
    && make CXXFLAGS="$CXXFLAGS -DNDEBUG -fPIC" -f GNUmakefile -j $MAKE_JOBS dynamic libcryptopp.pc \
    && make PREFIX="/usr" install-lib \
    && ln /usr/lib/libcryptopp.so.8.6.0 /usr/lib/libcryptopp.so.8 \
    && cd / \
    && rm -rf /opt/cryptopp \
# Build MegaCMD
    && git clone https://github.com/meganz/MEGAcmd.git /opt/MEGAcmd \
    && cd /opt/MEGAcmd \
    && git submodule update --init --recursive \
    && sh autogen.sh \
    && ./configure --without-ffmpeg --without-freeimage \
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
    && apk del make wget alpine-sdk autoconf automake libtool readline-dev sqlite-dev curl-dev c-ares-dev libraw-dev libsodium-dev eudev-dev libuv-dev linux-headers \
    && apk add --no-cache libsodium libuv