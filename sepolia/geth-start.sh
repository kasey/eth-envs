#! /usr/bin/env bash
#
GETH=$HOME/src/ethereum/go-ethereum/build/bin/geth
ETHENVS=/home/kasey/src/kasey/eth-envs/sepolia
ENVRUN=/var/lib/db/sepolia

mkdir -p $ENVRUN

#$GETH init --datadir $ENVRUN/geth genesis.json

$GETH \
	--sepolia \
	--http \
	--http.api eth,net,engine,admin,web3,debug \
	--authrpc.vhosts=* \
	--authrpc.jwtsecret=$ETHENVS/jwt.hex \
	--syncmode=full \
	--datadir ${ENVRUN}/geth





