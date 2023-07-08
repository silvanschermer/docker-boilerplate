FROM php:8.2-fpm-alpine

# remove default config files.
RUN find /usr/local/etc/php-fpm.d -maxdepth 1 -mindepth 1 -type f -exec rm -r '{}' \;
# create our own config file.
COPY ./php-fpm.conf /usr/local/etc/php-fpm.d/zzz-docker.conf

# Fix ext-sockets building error in php-upstream code base
ENV CFLAGS="$CFLAGS -D_GNU_SOURCE"

# install extension and build dependencies
RUN apk add --no-cache oniguruma-dev \
    && apk add --no-cache curl-dev \
    && apk add --no-cache libpng-dev \
    && apk add --no-cache build-base \
    && apk add --no-cache clang \
    && apk add --no-cache make \
    && apk add --no-cache cmake \
    && apk add --no-cache git \
    && apk add --no-cache libmnl-dev

WORKDIR /opt

# install libsocket for ext-socket com
RUN git clone https://github.com/dermesser/libsocket.git && \
    cd libsocket && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ && \
    make

## install php extensions through dockers extension wrapper
RUN docker-php-ext-install opcache \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install curl \
    && docker-php-ext-install gd \
    && docker-php-ext-install sockets

# switch back to the root document directory
WORKDIR /var/www/html

RUN chown -R 1000:1000 /var/www/html

# since we are not running as root we need to make sure these exist and are rw before we run the final CMD
RUN chown root:1000 /usr/local/var/log

RUN touch /usr/local/var/log/php-fpm.log \
    && chown root:1000 /usr/local/var/log/php-fpm.log \
    && chmod 060 /usr/local/var/log/php-fpm.log

# set user:group, expose port and start.
USER 1000:1000
EXPOSE 9000
CMD ["php-fpm"]