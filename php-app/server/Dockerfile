FROM nginx:1.25.1-alpine

COPY ./nginx.conf /etc/nginx/nginx.conf

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80
# EXPOSE 443

CMD ["nginx", "-g daemon off;"]
