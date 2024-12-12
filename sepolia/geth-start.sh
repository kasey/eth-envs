#! /usr/bin/env bash
#

ENVRUN=/var/lib/eth/sepolia
ETHENVS=$HOME/src/kasey/eth-envs/sepolia
CFG=$HOME/src/eth-clients/sepolia/metadata
GETH=$HOME/src/ethereum/go-ethereum/build/bin/geth

mkdir -p $ENVRUN

$GETH init --datadir $ENVRUN/geth $CFG/genesis.json

$GETH \
	--sepolia \
	--http \
	--http.api eth,net,engine,admin,web3,debug \
	--authrpc.vhosts=* \
	--authrpc.jwtsecret=$ETHENVS/jwt.hex \
	--syncmode=full \
	--datadir ${ENVRUN}/geth
