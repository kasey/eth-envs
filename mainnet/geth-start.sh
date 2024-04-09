#! /usr/bin/env bash
#
GETH=$HOME/src/ethereum/go-ethereum/build/bin/geth
ETHENVS=/home/kasey/src/kasey/eth-envs/mainnet
ENVRUN=/var/lib/eth/mainnet

$GETH \
	--http \
	--http.api eth,net,engine,admin,web3,debug \
	--http.corsdomain "*" \
	--authrpc.addr localhost \
	--authrpc.port 8551 \
	--authrpc.vhosts=* \
	--authrpc.jwtsecret=$ETHENVS/jwt.hex \
	--syncmode=full \
	--datadir ${ENVRUN}/geth
