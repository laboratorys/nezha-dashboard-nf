#!/bin/bash
run_backup(){
  if [[ -n "$BAK_APP_NAME" || -n "${BAK_APP_NAME}" ]]; then
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
  fi

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
  nohup  env NZ_DEBUG=true /app/dashboard &
}
run_agent(){
  if [[ -n "$NZ_UUID" || -n "${NZ_SERVER}" ]]; then
      (
          sleep 60
          ak=$(cat /app/data/config.yaml | grep "agent_secret_key" | awk '{print $2}')
          curl -s  -L https://raw.githubusercontent.com/nezhahq/scripts/main/agent/install.sh -o agent.sh \
          && chmod +x agent.sh \
          && env NZ_DEBUG=false NZ_SERVER=$NZ_SERVER NZ_TLS=true NZ_UUID=$NZ_UUID NZ_CLIENT_SECRET=$ak ./agent.sh
      ) &
  fi
}
# Check for command-line argument
case "$1" in
  --backup-only)
    run_backup
    ;;
  --dashboard-only)
    run_dashboard
    ;;
  --agent-only)
    run_agent
    ;;
  --nginx-only)
    nginx -g 'daemon off;'
    ;;
  --all)
    run_backup
    sleep 30
    run_dashboard
    run_agent
    nginx -g 'daemon off;'
    ;;
  *)
    run_backup
    sleep 30
    run_dashboard
    run_agent
    nginx -g 'daemon off;'
    ;;
esac