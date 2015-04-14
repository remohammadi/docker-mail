#!/bin/bash
service dovecot start

trap "{ service dovecot stop; }" EXIT

sleep infinity
