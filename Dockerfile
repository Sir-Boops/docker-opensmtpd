FROM alpine:3.7

ENV SMTPD_VER="6.0.3p1"

RUN addgroup -S _smtpd && \
		adduser -S -G _smtpd _smtpq

RUN apk -U add --virtual deps curl \
		gcc g++ fts-dev \
		libasr-dev libressl-dev \
		libevent-dev zlib-dev make \
		bison && \
	cd ~ && \
	curl --remote-name https://www.opensmtpd.org/archives/opensmtpd-$SMTPD_VER.tar.gz && \
	tar xf opensmtpd-$SMTPD_VER.tar.gz && \
	cd ~/opensmtpd-$SMTPD_VER && \
	./configure --prefix=/opt/opensmtpd \
		--with-path-queue=/opt/opensmtpd/queue && \
	make -j$(nproc) && \
	make install && \
	apk del --purge deps && \
	apk add libevent libasr fts && \
	mkdir -p /var/run && \
	rm -rf ~/* && rm -rf /opt/opensmtpd/etc/
