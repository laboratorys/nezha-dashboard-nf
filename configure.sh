#!/bin/bash
run_backup(){
  b_path="download/${BAK_VERSION-"latest"}"
  if [ "${BAK_VERSION-"latest"}" = "latest" ]; then
    b_path="latest/download"
  fi
  curl -s -L "https://github.com/laboratorys/backup2gh/releases/${b_path}/backup2gh-linux-amd64.tar.gz" -o backup2gh.tar.gz \
      && tar -xzf backup2gh.tar.gz \
      && rm backup2gh.tar.gz \
      && chmod +x backup2gh
  export WEB_PATH=/backup2gh
  nohup /app/backup2gh > /dev/null 2>&1 &
}
run_dashboard(){
  d_path="download/${NZ_VERSION-"latest"}"
  if [ "${NZ_VERSION-"latest"}" = "latest" ]; then
    d_path="latest/download"
  fi
  cd /app
  curl -s -L "https://github.com/nezhahq/nezha/releases/${d_path}/dashboard-linux-amd64.zip" -o dashboard-linux-amd64.zip \
     && unzip -q dashboard-linux-amd64.zip \
     && mv dashboard-linux-amd64 dashboard \
     && rm dashboard-linux-amd64.zip \
     && chmod +x dashboard
  nohup /app/dashboard &
}
run_agent(){
  if [ -n "$NZ_UUID" ]; then
      (
          sleep 60
          ak=$(cat /app/data/config.yaml | grep "agentsecretkey" | awk '{print $2}')
          curl -s  -L https://raw.githubusercontent.com/nezhahq/scripts/main/agent/install.sh -o agent.sh \
          && chmod +x agent.sh \
          && env NZ_DEBUG=false NZ_SERVER=localhost:8091 NZ_TLS=false NZ_UUID=$NZ_UUID NZ_CLIENT_SECRET=$ak ./agent.sh
      ) &
  fi
}
run_backup
sleep 30
run_dashboard
run_agent
nginx -g 'daemon off;'