#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-1000}
GROUP_ID=${LOCAL_GROUP_ID:-1000}

echo "Starting with UID : $USER_ID"
#useradd --shell /bin/bash -u $USER_ID -o -c "" -m ubuntu
adduser --disabled-password --gecos "" -u $USER_ID --gid $GROUP_ID --quiet ubuntu
export HOME=/home/ubuntu

exec /usr/sbin/gosu ubuntu "$@"
