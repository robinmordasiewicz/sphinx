#!/bin/bash
#

set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=robinhoodis
# image name
IMAGE=sphinx
docker build -t $USERNAME/$IMAGE:latest .
