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

RUN apt-get install -y git-core

RUN apt-get install -y \
        ucf \
        libc6 \
		tidy \
		libtidy-dev \
	&& docker-php-ext-install -j$(nproc) tidy \
	&& docker-php-ext-install -j$(nproc) mysqli

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
	&& php composer-setup.php --filename=composer --install-dir=/usr/local/bin/ \
	&& php -r "unlink('composer-setup.php');"