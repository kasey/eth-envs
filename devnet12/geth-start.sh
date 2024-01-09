#! /usr/bin/env bash
#
GETH=$HOME/src/ethereum/go-ethereum/build/bin/geth
ETHENVS=/home/kasey/src/kasey/eth-envs/devnet12
ENVRUN=/var/lib/db/devnet12
PANDACFG=/home/kasey/src/ethpandaops/dencun-devnets/network-configs/devnet-12

$GETH init --datadir $ENVRUN/geth $PANDACFG/genesis.json

$GETH \
	--http \
	--http.api eth,net,engine,admin,web3,debug \
	--authrpc.vhosts=* \
	--authrpc.jwtsecret=$ETHENVS/jwt.hex \
	--syncmode=full \
	--networkid=7011893062 \
	--datadir ${ENVRUN}/geth \
	--bootnodes $(curl -s https://config.dencun-devnet-12.ethpandaops.io/api/v1/nodes/inventory | jq -r '.ethereum_pairs[] | .execution.enode' | tr '\n' ',' | sed 's/,$/\n/') 

