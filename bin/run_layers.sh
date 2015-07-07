#!/bin/bash

set -x

get_git_repository() {
  layer_id=$1

  echo `redis-cli --raw get layer:$1:git`
}

fetch_branches() {
  layer_id=$1

  git ls-remote --heads `get_git_repository $1` | \
  awk '{print $2}' | \
  sed -e s/refs\\/heads\\/// | \
  xargs -I% redis-cli --raw sadd layer:$1:branches %
}

get_container_ip() {
  docker inspect --format="{{ .NetworkSettings.IPAddress }}" $1
}

get_next_stack_id() {
  max_stack_id=`redis-cli --raw lrange stack_ids 0 -1 | sort -gr | head -n 1`
  max_stack_id=${max_stack_id:-0}
  echo $((max_stack_id + 1))
}

create_stack() {
  stack_name=$1
  git_repository=$2
  git_branch=$3  

  docker run --name postgres-$stack_name -d postgres:9.4;
  
  docker rm -f app-$stack_name;
  docker run --name app-$stack_name \
  --link postgres-$stack_name:db \
  -e GIT_REPOSITORY=$git_repository \
  -e GIT_BRANCH=$git_branch \
  -d tadyjp/app:1

  redis-cli set stack:$stack_name:layer:1:name "app-$stack_name"
  redis-cli set stack:$stack_name:layer:1:ip `get_container_ip app-$stack_name`
  redis-cli set stack:$stack_name:layer:1:created_at `date +%s`
}

while true
do
  redis-cli rpush stack_ids 1 # add stack
  redis-cli rpush layer_ids 1 # add layer
  redis-cli set layer:1:git 'git@github.com:tadyjp/SampleRails422.git' # add layer1 git

  fetch_branches 1
  sleep 5
  create_stack `get_next_stack_id` 'git@github.com:tadyjp/SampleRails422.git' 'branch1'

  echo '-------------------------------------'
done

