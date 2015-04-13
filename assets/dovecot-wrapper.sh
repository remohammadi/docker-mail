#!/bin/bash
service dovecot start

trap "{ service dovecot stop; }" EXIT

tail -f /var/log/dovecot.log
