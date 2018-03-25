FROM alpine:3.7

ENV SMTPD_VER="6.0.3p1"

RUN apk -U add curl \
		gcc g++ fts-dev \
		libasr-dev libressl-dev \
		libevent-dev zlib-dev make \
		bison && \
	cd ~ && \
	curl --remote-name https://www.opensmtpd.org/archives/opensmtpd-$SMTPD_VER.tar.gz && \
	tar xf opensmtpd-$SMTPD_VER.tar.gz && \
	cd ~/opensmtpd-$SMTPD_VER && \
	./configure --prefix=/opt/openstmpd && \
	make -j$(nproc) && \
	make install && \
	apk del curl gcc g++ fts-dev \
		libasr-dev libressl-dev libevent-dev \
		zlib-dev make bison && \
	apk add libevent libasr fts && \
	rm -rf ~/* && rm -rf /opt/openstmpd/etc/*

RUN /opt/opensmtpd -d
