#!/bin/bash
#
# Startup script for mock system
#

#
# Check for config
#
if [ ! -e /config ] ; then
  echo "Missing config directory."
  echo "Use the volume mount to pass in configuration data."
  exit 1
fi

# Add the key, entrypoint and munge key
if [ -e /config/root ] ; then
  cp /config/root /root/.ssh/authorized_keys
  chmod 700 /root/.ssh
  chmod 600 /root/.ssh/authorized_keys
  chown -R root /root/.ssh
fi

#
# Add a test user if ADDUSER is defined
#
if [ ! -z "$ADDUSER" ] ; then
  USER=$(echo $ADDUSER|awk -F: '{print $1}')
  NUID=$(echo $ADDUSER|awk -F: '{print $2}')
  useradd -m $USER -u $NUID -s /bin/bash
  if [ -e /config/$USER ] ; then
    mkdir /home/$USER/.ssh
    cp /config/$USER /home/$USER/.ssh/authorized_keys
    chown $USER -R /home/$USER/.ssh/
    chmod 700 /home/$USER/.ssh
    chmod 600 /home/$USER/.ssh/authorized_keys
  fi
fi

# Start up sshd (typically a bad idea)
#
/usr/sbin/sshd -D
