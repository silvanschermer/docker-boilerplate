#!/bin/sh
export NGINX_CONTAINER_IP=$(hostname -i)
exec "$@"