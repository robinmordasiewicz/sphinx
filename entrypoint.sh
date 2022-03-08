#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback
#
if [ "$LOCAL_USER_ID" != "" ]; then
  USER_ID=${LOCAL_USER_ID:-9001}

  echo "Starting with UID : $USER_ID"
  adduser -D -h /home/user -s /bin/sh -u $USER_ID user
  export HOME=/home/user
fi

exec "$@"
