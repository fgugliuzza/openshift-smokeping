FROM lsiobase/alpine:3.9

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SMOKEPING_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="ironicbadger,sparklyballs"

# copy tcpping script
COPY tcpping /defaults/

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	apache2 \
	apache2-ctl \
	apache2-utils \
	bc \
	bind-tools \
	curl \
	smokeping \
	ssmtp \
	sudo \
	tcptraceroute \
	ttf-dejavu \
	popt \
	libidn \
	openssl && \
 echo "**** give abc sudo access to traceroute & tcptraceroute ****" && \
 echo \
 "abc ALL=(ALL) NOPASSWD: /usr/bin/traceroute" >> \
	/etc/sudoers.d/traceroute && \
 echo \
 "abc ALL=(ALL) NOPASSWD: /usr/bin/tcptraceroute" >> \
	/etc/sudoers.d/tcptraceroute && \
 echo "**** fix path to cropper.js ****" && \
 sed -i 's#src="/cropper/#/src="cropper/#' /etc/smokeping/basepage.html && \
 echo "**** install tcping script ****" && \
 install -m755 -D /defaults/tcpping /usr/bin/ && \
 echo "**** remove default apache conf ****" && \
 rm -f /etc/apache2/httpd.conf

# add local files
COPY root/ /

# extract echoping archive
ADD echoping.tar.gz /

# USER 1001

# ports and volumes
EXPOSE 8080
VOLUME /config /data
