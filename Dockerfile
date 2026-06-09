FROM ghcr.io/nginxinc/nginx-unprivileged:stable
ENV TZ=Asia/Shanghai

USER root

RUN apk update && apk add --no-cache \
    bash \
    curl \
    unzip \
    wget \
    apache2-utils \
    procps \
    vim \
    dcron \
    && touch /var/log/cron.log

WORKDIR /app

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY configure.sh /app/configure.sh
RUN chmod +x /app/configure.sh

COPY check_backup2gh.sh /app/check_backup2gh.sh
RUN chmod +x /app/check_backup2gh.sh

RUN echo "*/10 * * * * /app/check_backup2gh.sh >> /var/log/cron.log 2>&1" > /var/spool/cron/crontabs/root \
    && echo "" >> /var/spool/cron/crontabs/root \
    && chmod 0600 /var/spool/cron/crontabs/root

ENTRYPOINT ["bash", "/app/configure.sh"]