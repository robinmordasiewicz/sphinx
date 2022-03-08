#!/bin/bash
#

docker build -t videothedocs:v9 -f Dockerfile .
docker push 
