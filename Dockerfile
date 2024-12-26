FROM nginx:stable
ENV TZ=Asia/Shanghai
RUN apt-get update \
    && apt-get -y install bash curl unzip wget apache2-utils

WORKDIR /app

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY configure.sh /app/configure.sh
RUN chmod +x /app/configure.sh

ENTRYPOINT ["bash", "/app/configure.sh"]

