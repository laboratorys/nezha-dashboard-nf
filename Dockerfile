FROM public.ecr.aws/nginx/nginx:stable
ENV TZ=Asia/Shanghai

RUN apt-get update \
    && apt-get -y install bash curl unzip wget apache2-utils procps vim cron \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && touch /var/log/cron.log

WORKDIR /app

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY configure.sh /app/configure.sh
RUN chmod +x /app/configure.sh

COPY check_backup2gh.sh /app/check_backup2gh.sh
RUN chmod +x /app/check_backup2gh.sh

RUN echo "*/10 * * * * root /app/check_backup2gh.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/backup2gh_check \
    && echo "" >> /etc/cron.d/backup2gh_check \
    && chmod 0644 /etc/cron.d/backup2gh_check

ENTRYPOINT ["bash", "/app/configure.sh"]