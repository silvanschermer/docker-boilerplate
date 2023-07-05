FROM php:8.2-fpm-alpine

WORKDIR /var/www/html

RUN mkdir /var/run/php-fpm \
&& chmod ug+rw /var/run/php-fpm

RUN find /usr/local/etc/php-fpm.d -maxdepth 1 -mindepth 1 -type f -exec rm -r '{}' \;

COPY ./php-fpm.conf /usr/local/etc/php-fpm.d/zzz-docker.conf

# Fix ext-sockets building error in php-upstream code base
ENV CFLAGS="$CFLAGS -D_GNU_SOURCE"

RUN apk add --no-cache oniguruma-dev \
    && apk add --no-cache curl-dev \
    && apk add --no-cache libpng-dev \
    && apk add build-base \
    && apk add clang \
    && apk add make \
    && apk add cmake \
    && apk add git \
    && apk add libmnl-dev

WORKDIR /opt

RUN git clone https://github.com/dermesser/libsocket.git && \
    cd libsocket && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ && \
    make

RUN docker-php-ext-install opcache \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install curl \
    && docker-php-ext-install gd \
    && docker-php-ext-install sockets

RUN docker-php-ext-enable opcache

WORKDIR /var/www/html

RUN chown -R 1000:1000 /var/www/html
RUN chown root:1000 /usr/local/var/log
RUN touch /usr/local/var/log/php-fpm.log
RUN chown root:1000 /usr/local/var/log/php-fpm.log
RUN chmod 060 /usr/local/var/log/php-fpm.log

USER 1000:1000

EXPOSE 9000

CMD ["php-fpm"]
# TODO: clean installation