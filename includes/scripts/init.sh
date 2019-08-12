#!/bin/bash

/etc/init.d/php7.2-fpm start
/etc/init.d/nginx start
/etc/init.d/cron start

sleep infinity