#!/bin/bash
#

set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=robinhoodis
# image name
IMAGE=sphinx-build
docker build -t $USERNAME/$IMAGE:latest .
