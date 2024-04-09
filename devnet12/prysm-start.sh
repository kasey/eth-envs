#! /usr/bin/env bash
# set +x

ETHENVS=/home/kasey/src/kasey/eth-envs/devnet12
ENVRUN=/var/lib/db/devnet12
PANDACFG=/home/kasey/src/ethpandaops/dencun-devnets/network-configs/devnet-12
PRYSMSRC=$HOME/src/prysmaticlabs/prysm
PRYSMRUN=$ENVRUN/prysm
CPURL=https://checkpoint-sync.dencun-devnet-12.ethpandaops.io

# prysm will automatically make the directory, but not before the logger fails to init the log file.
# so manually make the dir for clean logging.
mkdir -p $PRYSMRUN

pushd $PRYSMSRC

bazel build //cmd/beacon-chain -c dbg  

CPFLAGS=""
if [ "$1" = "checkpoint" ]; then
	CPFLAGS="--checkpoint-sync-url=${CPURL} --genesis-beacon-api-url=${CPURL}"
fi

$PRYSMSRC/bazel-bin/cmd/beacon-chain/beacon-chain_/beacon-chain ${CPFLAGS} \
--genesis-state=${PANDACFG}/genesis.ssz \
--chain-config-file=${PANDACFG}/config.yaml \
--contract-deployment-block=0 \
--min-sync-peers=1 \
--verbosity=debug \
--subscribe-all-subnets \
--bootstrap-node=$(curl -s https://config.dencun-devnet-12.ethpandaops.io/api/v1/nodes/inventory | jq -r '.ethereum_pairs[] | .consensus.enr' | tr '\n' ','| sed 's/,$/\n/') \
--execution-endpoint=http://localhost:8551 \
--datadir=${PRYSMRUN} \
--enable-debug-rpc-endpoints \
--grpc-max-msg-size=65568081 \
--jwt-secret=${ETHENVS}/jwt.hex \
--accept-terms-of-use \
--pprof \
--log-file=${PRYSMRUN}/beacon.log

popd

