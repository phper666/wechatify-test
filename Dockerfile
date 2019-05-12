ARG ALPHP_TYPE=cli
FROM swoft/alphp:${ALPHP_TYPE}
LABEL maintainer="liyuzhao <562405704@qq.com>" version="1.0"

RUN set -ex \
        && php -m \
        # install some tools
        && apk update \
        && apk add --no-cache \
            php7-fpm php7-pcntl php-xmlwriter\
            vim wget net-tools git zip unzip apache2-utils \
            # vim wget net-tools git zip unzip apache2-utils mysql-client redis \
        && apk del --purge *-dev \
        && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
        # install latest composer
        && wget https://getcomposer.org/composer.phar \
        && mv composer.phar /usr/local/bin/composer \
        && cd /usr/local/bin \
        && chmod 0777 composer \
        # - config PHP-FPM
        && cd /etc/php7 \
        && { \
            echo "[global]"; \
            echo "pid = /var/run/php-fpm.pid"; \
            echo "[www]"; \
            echo "user = www-data"; \
            echo "group = www-data"; \
        } | tee php-fpm.d/custom.conf \
        # config site
        && chown -R www-data:www-data /var/www \
        && { \
            echo "#!/bin/sh"; \
            # echo "php /var/www/uem.phar taskServer:start -d"; \
            echo "php-fpm7 -F"; \
        } | tee /run.sh \
        && chmod 755 /run.sh

# 这里后面需要改下
ADD . /var/www/swoft
VOLUME ["/var/logs", "/var/swoft/runtime/logs"]

WORKDIR /var/www/swoft

# 因为swoft2包管理没有上传，只有在github上，所以打包时需要一个token，目前这个token是我的,只有拉取数据的权限
RUN composer config --global --auth github-oauth.github.com e7a35bf77f2efb01a5f43022553471487013235f
RUN composer install --no-dev
RUN mv -vr ./depend/service-governance  ./vendor/swoft/component/src/service-governance
RUN composer dump-autoload -o \
    && composer clearcache

EXPOSE 9501

CMD /run.sh
