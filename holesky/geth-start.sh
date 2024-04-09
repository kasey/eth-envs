#! /usr/bin/env bash
#
GETH=$HOME/src/ethereum/go-ethereum/build/bin/geth
ETHENVS=/home/kasey/src/kasey/eth-envs/holesky
ENVRUN=/var/lib/db/holesky

mkdir -p $ENVRUN

$GETH \
	--holesky \
	--http \
	--http.api eth,net,engine,admin,web3,debug \
	--authrpc.vhosts=* \
	--authrpc.jwtsecret=$ETHENVS/jwt.hex \
	--syncmode=full \
	--networkid=17000 \
	--datadir ${ENVRUN}/geth \

