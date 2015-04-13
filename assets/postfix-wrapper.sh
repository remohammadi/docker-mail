#!/bin/bash
service postfix start

trap "{ service postfix stop; }" EXIT

tail -f /var/log/mail.log
