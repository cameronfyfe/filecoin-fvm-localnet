_:
    @just --list

# Get info for an ethereum "0x" address
addr-info ETH_ADDR:
    docker compose exec lotus lotus evm stat {{ETH_ADDR}}

# Get FIL for a given f4 or f3 address
get-fil ADDR AMT:
    docker compose exec lotus lotus send {{ADDR}} {{AMT}}

# Run a command from the localnet docker environment
in-docker +CMD:
    docker compose exec boost {{CMD}}

# Run boost client cli from the localnet docker environment
in-docker-boost +ARGS:
    docker compose exec --env FULLNODE_API_INFO=http://lotus:1234 boost boost {{ARGS}}

# Init boost client and copy over lotus wallet
boost-init:
    just in-docker-boost init
    just in-docker scripts/copy-wallet-from-lotus-to-boost.sh 

# Fund market balance for default wallet
fund-market-balance AMT:
    just in-docker lotus wallet market add {{AMT}} 

# Propose a storage deal
do-deal START_EPOCH:
    just in-docker-boost deal \
        --http-url 'https://raw.githubusercontent.com/cameronfyfe/filecoin-fvm-localnet/main/data-for-deals/data-1.car' \
        --provider f01000 \
        --payload-cid bafk2bzacea2fmdp7kv2c5ffrwuuacaqak7t43wrt2k42barouc45uwepmnyao \
        --car-size 1125 \
        --commp baga6ea4seaqcin6wos33py5vyhsgmwnakzaakrpho4hrdmzpkbnmcvywnnpncdi \
        --piece-size 2048 \
        --duration 655200 \
        --start-epoch {{START_EPOCH}} \
        --storage-price 100000000 \
        --verified false \
    ;

