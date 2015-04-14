#!/bin/bash
service postfix start

trap "{ service postfix stop; }" EXIT

sleep infinity
