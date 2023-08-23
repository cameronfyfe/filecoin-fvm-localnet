#!/usr/bin/env bash

START_EPOCH=${1:-100000}

docker compose exec \
  --env FULLNODE_API_INFO=http://lotus:1234 \
  boost \
  boost deal \
    --http-url 'https://raw.githubusercontent.com/cameronfyfe/filecoin-fvm-localnet/main/data-for-deals/data-1.car' \
    --provider f01000 \
    --payload-cid bafk2bzacea2fmdp7kv2c5ffrwuuacaqak7t43wrt2k42barouc45uwepmnyao \
    --car-size 1125 \
    --commp baga6ea4seaqcin6wos33py5vyhsgmwnakzaakrpho4hrdmzpkbnmcvywnnpncdi \
    --piece-size 2048 \
    --duration 655200 \
    --start-epoch $START_EPOCH \
    --storage-price 100000000 \
    --verified false \
;
