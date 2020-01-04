FROM alpine:3.11

ENV SMTPD_VER="6.6.1p1"

RUN addgroup -S _smtpd && \
	adduser -S -u 991 -G _smtpd _smtpd && \
	addgroup -S _smtpq && \
	adduser -S -u 992 -G _smtpq _smtpq && \
	addgroup -S vmail && \
	adduser -S -u 993 -G vmail vmail

RUN apk -U add --virtual deps curl \
		gcc g++ fts-dev \
		libasr-dev libressl-dev \
		libevent-dev zlib-dev make \
		bison && \
	apk add libevent libasr fts libressl  && \
	cd ~ && \
	curl --remote-name https://www.opensmtpd.org/archives/opensmtpd-$SMTPD_VER.tar.gz && \
	tar xf opensmtpd-$SMTPD_VER.tar.gz && \
	cd ~/opensmtpd-$SMTPD_VER && \
	./configure --prefix=/opt/opensmtpd \
		--with-path-queue=/opt/opensmtpd/queue && \
	make -j$(nproc) && \
	make install && \
	apk del --purge deps && \
	mkdir -p /var/run && \
	rm -rf ~/* && rm -rf /opt/opensmtpd/etc/

CMD /opt/opensmtpd/sbin/smtpd -d
