![FVM Localnet build status](https://github.com/filecoin-project/filecoin-fvm-localnet/actions/workflows/filecoin-fvm-localnet-combined.yml/badge.svg)

# Filecoin FVM localnet

Filecoin FVM Localnet is a complete Filecoin [Lotus](https://lotus.filecoin.io/) and [Boost](https://boost.filecoin.io/) Docker image that allows you to spin up a localnet for FVM smart contract development.


## System requirements

ARM64 (e.g. Macbook M1/M2s) or AMD64 (e.g. x86 Linux / Windows / MacOS).

## Prerequisites

Ensure you have [Docker installed](https://docs.docker.com/get-docker/). 

## Installation

**Please note**, that running the commands below will result in docker downloading a 3GB image on first run (or 7GB if you choose to run an 8M network). So if you are going to be running this at somewhere with poor or metered internet connectivity, please be aware.

1. Clone this repository:

    ```sh
    git clone https://github.com/filecoin-project/filecoin-fvm-localnet.git
    ```

1. Navigate to the repository:

    ```sh
    cd filecoin-fvm-localnet
    ```
    
1. OPTIONAL: Edit the file `.env` if you wish to optionally run an 8M sector network, otherwise the default 2k sectors will be used

1. Run Docker `compose up`:

    ```sh
    docker compose up
    ```

1. To stop the network type `ctrl-c`.

Once the localnet is started, you can navigate the Boost UI at: `http://localhost:8080`. 

## Make a Storage Deal

These instructions are for simply submitting a 2kB storage deal from the default lotus wallet that's created using the boost client.

Install `just` if not already installed.

1. Initialize boost client and copy the default lotus wallet over to boost
    ```bash
    just boost-init
    ```

1. Add funds to market actor
    ```bash
    just fund-market-balance 100

    # then wait for tx to go on chain (~1 min)
    ```


1. Submit storage deal
    ```bash
    just do-deal <start_epoch>
    ```

## Metamask and Funding a Wallet

### Setting up Metamask

You can configure metamask to connect to this local network by adding a new custom network, with the following steps:

1. Click the network at the top of Metamask
1. Click `Add a network manually` at the bottom
1. Enter the network information below

    ```
    Network name: Filecoin localnet
    New RPC URL: http://127.0.0.1:1234/rpc/v1
    Chain ID: 31415926
    Currency symbol: tFIL
    ```

### Funding a wallet

In order to transact with the network, you will need some funds (tFIL) in your wallet, you can fund a wallet using the `lotus` command:

1. First find out the `t4` address of your wallet from its `0x` address shown in Metamask:

    ```
    docker compose exec lotus lotus evm stat 0x403D6E3Aff483A3c727Df731c6720A49E36De3eb
    ```
    ```
    Filecoin address:  t410fia6w4ox7ja5dy4t564y4m4qkjhrw3y7ldcn3u3q
    Eth address:  0x403d6e3aff483a3c727df731c6720a49e36de3eb
    Actor lookup failed for faddr t410fia6w4ox7ja5dy4t564y4m4qkjhrw3y7ldcn3u3q with error: resolution lookup failed (t410fia6w4ox7ja5dy4t564y4m4qkjhrw3y7ldcn3u3q): resolve address t410fia6w4ox7ja5dy4t564y4m4qkjhrw3y7ldcn3u3q: actor not found
    ```

1. Then send some funds to that wallet using the t4 address above:
    ```
    docker compose exec lotus lotus send t410fia6w4ox7ja5dy4t564y4m4qkjhrw3y7ldcn3u3q 1000
    ```
    ```
    bafy2bzacecdtzoq6llosskugezsmtlefxjbjww3pddj42iqgqa3vcalgjm6rs
    ```
   The funds will show up in your metamask wallet in around 45 seconds.
    

## Usage notes

- This network has a sector size of 2KiB. This means that the largest storage deals you can make with the miner will be 2KiB. If you want an 8MiB network and storage deals of up to 8MiB, then uncomment the appropriate section in the `.env` file, delete the `data/` directory and restart docker compose.

- The localnet will take a while to start up -- around 5 - 10 minutes depending on how quickly it can download the docker image and initial proof data.

- If you have not started the network for a while, then it may take a while to re-sync with itself. If you wish to avoid the wait and wish to reset the network (losing any local state) then you can delete the `data` directory.

- This network has a block time of 15 seconds (half the time of Filecoin mainnet).



