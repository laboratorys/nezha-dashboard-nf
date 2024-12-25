FROM nginx:stable
ENV TZ=Asia/Shanghai
RUN apt-get update \
    && apt-get -y install bash curl unzip wget apache2-utils

WORKDIR /app
RUN curl -L "https://github.com/laboratorys/backup2gh/releases/latest/download/backup2gh-linux-amd64.tar.gz" -o backup2gh.tar.gz \
    && tar -xzf backup2gh.tar.gz \
    && rm backup2gh.tar.gz \
    && chmod +x backup2gh

RUN curl -L "https://github.com/nezhahq/nezha/releases/latest/download/dashboard-linux-amd64.zip" -o dashboard-linux-amd64.zip \
    && unzip dashboard-linux-amd64.zip \
    && mv dashboard-linux-amd64 dashboard \
    && rm dashboard-linux-amd64.zip \
    && chmod +x dashboard

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY configure.sh /app/configure.sh
RUN chmod +x /app/configure.sh

ENTRYPOINT ["bash", "/app/configure.sh"]

