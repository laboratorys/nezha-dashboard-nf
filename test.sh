docker build -t nezha-dashboard-nf .
docker stop nezha-dashboard-nf
docker rm nezha-dashboard-nf
docker run -d -p 8090:8090 -p 8091:8091 --name nezha-dashboard-nf nezha-dashboard-nf
