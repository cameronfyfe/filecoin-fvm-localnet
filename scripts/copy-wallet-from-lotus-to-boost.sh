#!/usr/bin/env bash

set -xeu

ADDR=$(lotus wallet default)

EXPORT=$(lotus wallet export $ADDR)

echo $EXPORT | FULLNODE_API_INFO=http://lotus:1234 boost wallet import

FULLNODE_API_INFO=http://lotus:1234 boost wallet set-default $ADDR

