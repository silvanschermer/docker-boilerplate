FROM nginx:1.25.1-alpine


COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./error.log /var/log/nginx/error.log

EXPOSE 80
# EXPOSE 443

CMD ["nginx", "-g daemon off;"]

USER 1000:1000