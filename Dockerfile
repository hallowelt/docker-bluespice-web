FROM ubuntu:bionic

# Setting environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Copying entrypoint script into the container image
COPY ./includes/scripts/* /opt/docker/

# apt-utils for parallel configuration of the packages
RUN apt-get update; \
	apt-get -y --no-install-recommends install apt-utils; \
	apt-get -y dist-upgrade

# Deploy necessary packages
RUN apt-get -y --no-install-recommends install \
	apt-transport-https \
	cron \
	logrotate \
	gnupg2 \
	imagemagick \
	bzip2 \
	unzip \
	nginx \
	php-fpm \
	php-xml \
	php-mbstring \
	php-curl \
	php-zip \
	php-gd \
	php-tidy \
	php-cli \
	php-json \
	php-mysql \
	php-mysqli \
	php-ldap \
	php-opcache \
	php-memcache \
	php-memcached \
	php-intl \
	php-pear \
	php-iconv \
	php-mcrypt \
	inkscape \
	wget \
	python3 \
	poppler-utils \
	dvipng \
	ocaml \
	build-essential

# Development and debugging
RUN apt-get -y --no-install-recommends install \
	curl \
	vim

# Install Ghostscript
RUN cd /tmp; \
	wget --no-check-certificate https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs926/ghostscript-9.26-linux-x86_64.tgz; \
	tar xzf ghostscript-9.26-linux-x86_64.tgz; \
	cp /tmp/ghostscript-9.26-linux-x86_64/gs-926-linux-x86_64 /usr/local/bin/gs; \
	rm -rf /tmp/ghostscript-9.26-linux-x86_64; \
	rm -f /tmp/ghostscript-9.26-linux-x86_64.tgz

# General Configuration
RUN sed -i 's/^max_execution_time.*$/max_execution_time = 600/g' /etc/php/7.2/fpm/php.ini; \
	sed -i 's/^post_max_size.*$/post_max_size = 128M/g' /etc/php/7.2/fpm/php.ini; \
	sed -i 's/^upload_max_filesize.*$/upload_max_filesize = 128M/g' /etc/php/7.2/fpm/php.ini; \
	sed -i 's/^;date.timezone.*$/date.timezone = Europe\/Berlin/g' /etc/php/7.2/fpm/php.ini; \
	sed -i 's/^memory_limit*$/memory_limit = 512M/g' /etc/php/7.2/fpm/php.ini; \
	sed -i 's/^;opcache.enable=.*$/opcache.enable=1/g' /etc/php/7.2/fpm/php.ini; \
	sed -i 's/^;opcache.memory_consumption.*$/opcache.memory_consumption=512/g' /etc/php/7.2/fpm/php.ini; \
	sed -i 's/^;opcache.max_accelerated_files.*$/opcache.max_accelerated_files=1000000/g' /etc/php/7.2/fpm/php.ini; \
	sed -i 's/^;opcache.validate_timestamps.*$/opcache.validate_timestamps=1/g' /etc/php/7.2/fpm/php.ini; \
	sed -i 's/^;opcache.revalidate_freq.*$/opcache.revalidate_freq=2/g' /etc/php/7.2/fpm/php.ini; \
	sed -i 's/^;opcache.optimization_level.*$/opcache.optimization_level=0x7FFF9FFF/g' /etc/php/7.2/fpm/php.ini; \
	sed -i 's/^zlib.output_compression.*$/zlib.output_compression=On/g' /etc/php/7.2/fpm/php.ini; \
	sed -i 's/^;zlib.output_compression_level.*$/zlib.output_compression_level=9/g' /etc/php/7.2/fpm/php.ini; \
	sed -i 's/^;sendmail_path.*$/sendmail_path=\/usr\/sbin\/sendmail -S mail:2025/g' /etc/php/7.2/fpm/php.ini; \
	mkdir /run/php; \
	chown -Rf www-data:www-data /run/php

COPY ./includes/configs/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./includes/configs/nginx/www.conf /etc/php/7.2/fpm/pool.d/www.conf

COPY ./includes/misc/cron /etc/cron.d/bluespice
COPY ./includes/misc/logrotate /etc/logrotate.d/
RUN chmod 0644 /etc/cron.d/bluespice; \
	mkdir /var/log/bluespice; \
	touch /var/log/bluespice/cron.log

ENTRYPOINT /opt/docker/init.sh