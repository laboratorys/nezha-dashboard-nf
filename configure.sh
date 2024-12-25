#!/bin/bash
export WEB_PATH=/backup2gh
nohup /app/backup2gh > /dev/null 2>&1 &
sleep 30
nohup /app/dashboard &
if [ -n "$AGENT_UUID" ]; then
    (
        sleep 60
        ak=$(cat /app/data/config.yaml | grep "agentsecretkey" | awk '{print $2}')
        curl -L https://raw.githubusercontent.com/nezhahq/scripts/main/agent/install.sh -o agent.sh \
        && chmod +x agent.sh \
        && env NZ_SERVER=localhost:8091 NZ_TLS=false NZ_UUID=$AGENT_UUID NZ_CLIENT_SECRET=$ak ./agent.sh
    ) &
fi

nginx -g 'daemon off;'