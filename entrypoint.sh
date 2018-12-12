#!/usr/bin/env bash

mkdir -p /root/.ssh
touch /root/.ssh/authorized_keys

chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys
chown root:root /root/.ssh/authorized_keys

/usr/sbin/sshd -D
