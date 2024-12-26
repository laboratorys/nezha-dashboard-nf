docker build -t nezha-dashboard-nf .
docker stop nezha-dashboard-nf
docker rm nezha-dashboard-nf
docker run -d -p 8090:8090 -p 8091:8091 \
 -e BAK_APP_NAME="zzz" \
 -e WEB_PWD="12345" \
 -e BAK_DATA_DIR="/app/data" \
 -e BAK_MAX_COUNT="2" \
 -e RUN_MODE="2" \
 -e BAK_LOG="1" \
 -e BAK_REPO="zzz" \
 -e BAK_REPO_OWNER="zzz" \
 -e BAK_GITHUB_TOKEN="zzz" \
 -e NZ_VERSION="v1.4.4" \
 -e BAK_VERSION="V1.3"
  --name nezha-dashboard-nf nezha-dashboard-nf
