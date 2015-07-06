#!/bin/bash


docker rm -f router-redis; \
  docker run --name router-redis -p 6379:6379 -d redis:latest

docker rm -f router-web; \
  docker run --name router-web -p 80:80 --link router-redis:redis -d tadyjp/router:1

