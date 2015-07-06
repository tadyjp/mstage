#!/bin/bash

set -x

docker build -t tadyjp/router:1 router

docker build -t tadyjp/app:1 app

