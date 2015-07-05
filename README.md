


# build

docker build -t tadyjp/app:1 app


docker build -t tadyjp/router:1 router




# run

docker run --name postgres-hash1 -d postgres:9.4

docker rm -f router-redis; \
  docker run --name router-redis -p 6379:6379 -d redis:latest

docker rm -f router; \
  docker run --name router -p 80:80 --link router-redis:redis -d tadyjp/router:1

docker rm -f app-hash1; \
  docker run --name app-hash1 --link postgres-hash1:db -d tadyjp/app:1


# etc


docker exec -it <id> bash

docker rm -f $(docker ps -a | awk '{print $1}')
docker rmi $(docker images | grep '<none>' | awk '{print $3}')



