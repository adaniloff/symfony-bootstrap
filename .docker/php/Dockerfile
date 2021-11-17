FROM php:8.0-fpm

ARG UID
ENV UID=$UID
ARG PROJECT_PATH
ENV PROJECT_PATH=$PROJECT_PATH

RUN groupadd dev -g $UID
RUN useradd dev -u $UID -g dev -d /home/dev -m

RUN apt-get update \
    && apt-get install -y --no-install-recommends vim curl debconf git apt-transport-https apt-utils \
    build-essential locales acl mailutils wget zip unzip \
    gnupg gnupg1 gnupg2
COPY php.ini /etc/php/8.0/php.ini
COPY php-fpm-pool.conf /etc/php/8.0/pool.d/www.conf

RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls && \
   mv composer.phar /usr/local/bin/composer

RUN rm -rf /var/lib/apt/lists/*
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen

USER dev
WORKDIR $PROJECT_PATH/

EXPOSE 9000
CMD ["php-fpm"]
