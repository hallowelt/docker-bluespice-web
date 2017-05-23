FROM php:7.0-apache
RUN apt-get update
RUN apt-get install -y vim
RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN apt-get install -y \
        ucf \
        libc6 \
		tidy \
		libtidy-dev \
	&& docker-php-ext-install -j$(nproc) tidy \
	&& docker-php-ext-install -j$(nproc) mysqli