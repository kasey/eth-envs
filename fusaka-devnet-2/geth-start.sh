#! /usr/bin/env bash
#

ENVRUN=/var/lib/eth/sepolia
ETHENVS=$HOME/src/kasey/eth-envs/fusaka-devnet-2
GETH=$HOME/src/ethereum/go-ethereum/build/bin/geth
PANDA=$HOME/src/ethpandaops/fusaka-devnets/network-configs/devnet-2/metadata
NETWORKID=7092821360

mkdir -p $ENVRUN

$GETH init --datadir $ENVRUN/geth $PANDA/genesis.json

$GETH \
	--http \
	--http.api eth,net,engine,admin,web3,debug \
	--authrpc.vhosts=* \
        --networkid=$NETWORKID \
	--authrpc.jwtsecret=$ETHENVS/jwt.hex \
	--syncmode=full \
	--datadir ${ENVRUN}/geth \
	--bootnodes `cat $PANDA/bootstrap_nodes.txt | tr -s '\n' ', '`
