#! /usr/bin/env bash
set -e

ETHENVS=/home/kasey/src/kasey/eth-envs/sepolia
ENVRUN=/var/lib/db/sepolia
CFG=$HOME/src/eth-clients/sepolia/bepolia
PRYSMSRC=$HOME/src/prysmaticlabs/prysm
PRYSMRUN=$ENVRUN/prysm
CPURL=https://checkpoint-sync.sepolia.ethpandaops.io

# prysm will automatically make the directory, but not before the logger fails to init the log file.
# so manually make the dir for clean logging.
mkdir -p $PRYSMRUN

pushd $PRYSMSRC

bazel build //cmd/beacon-chain -c dbg

CPFLAGS=""
if [ "$1" = "checkpoint" ]; then
        CPFLAGS="--checkpoint-sync-url=${CPURL} --genesis-beacon-api-url=${CPURL} --enable-experimental-backfill"
fi

$PRYSMSRC/bazel-bin/cmd/beacon-chain/beacon-chain_/beacon-chain ${CPFLAGS} \
--sepolia \
--genesis-state=${CFG}/genesis.ssz \
--contract-deployment-block=0 \
--min-sync-peers=1 \
--verbosity=debug \
--subscribe-all-subnets \
--genesis-state=${ETHENVS}/genesis.ssz \
--bootstrap-node=enr:-Iq4QMCTfIMXnow27baRUb35Q8iiFHSIDBJh6hQM5Axohhf4b6Kr_cOCu0htQ5WvVqKvFgY28893DHAg8gnBAXsAVqmGAX53x8JggmlkgnY0gmlwhLKAlv6Jc2VjcDI1NmsxoQK6S-Cii_KmfFdUJL2TANL3ksaKUnNXvTCv1tLwXs0QgIN1ZHCCIyk \
--bootstrap-node=enr:-Ly4QFoZTWR8ulxGVsWydTNGdwEESueIdj-wB6UmmjUcm-AOPxnQi7wprzwcdo7-1jBW_JxELlUKJdJES8TDsbl1EdNlh2F0dG5ldHOI__78_v2bsV-EZXRoMpA2-lATkAAAcf__________gmlkgnY0gmlwhBLYJjGJc2VjcDI1NmsxoQI0gujXac9rMAb48NtMqtSTyHIeNYlpjkbYpWJw46PmYYhzeW5jbmV0cw-DdGNwgiMog3VkcIIjKA \
--bootstrap-node=enr:-KG4QE5OIg5ThTjkzrlVF32WT_-XT14WeJtIz2zoTqLLjQhYAmJlnk4ItSoH41_2x0RX0wTFIe5GgjRzU2u7Q1fN4vADhGV0aDKQqP7o7pAAAHAyAAAAAAAAAIJpZIJ2NIJpcISlFsStiXNlY3AyNTZrMaEC-Rrd_bBZwhKpXzFCrStKp1q_HmGOewxY3KwM8ofAj_ODdGNwgiMog3VkcIIjKA \
--bootstrap-node=enr:-L64QC9Hhov4DhQ7mRukTOz4_jHm4DHlGL726NWH4ojH1wFgEwSin_6H95Gs6nW2fktTWbPachHJ6rUFu0iJNgA0SB2CARqHYXR0bmV0c4j__________4RldGgykDb6UBOQAABx__________-CaWSCdjSCaXCEA-2vzolzZWNwMjU2azGhA17lsUg60R776rauYMdrAz383UUgESoaHEzMkvm4K6k6iHN5bmNuZXRzD4N0Y3CCIyiDdWRwgiMo \
--execution-endpoint=http://localhost:8551 \
--datadir=${PRYSMRUN} \
--enable-debug-rpc-endpoints \
--grpc-max-msg-size=65568081 \
--jwt-secret=${ETHENVS}/jwt.hex \
--accept-terms-of-use \
--pprof \
--log-file=${PRYSMRUN}/beacon.log

popd

