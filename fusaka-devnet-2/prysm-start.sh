#! /usr/bin/env bash
set -e

ENVRUN=/var/lib/eth/fusaka-devnet-2
ETHENVS=$HOME/src/kasey/eth-envs/fusaka-devnet-2
PANDA=$HOME/src/ethpandaops/fusaka-devnets/network-configs/devnet-2/metadata
PRYSMSRC=$HOME/src/prysmaticlabs/prysm
PRYSMRUN=$ENVRUN/prysm
CPURL=https://checkpoint-sync.fusaka-devnet-2.ethpandaops.io/

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
--genesis-state=${PANDA}/genesis.ssz \
--chain-config-file=${PANDA}/config.yaml \
--genesis-state=${PANDA}/genesis.ssz \
--contract-deployment-block=0 \
--min-sync-peers=1 \
--verbosity=debug \
--execution-endpoint=http://localhost:8551 \
--datadir=${PRYSMRUN} \
--enable-debug-rpc-endpoints \
--grpc-max-msg-size=65568081 \
--jwt-secret=${ETHENVS}/jwt.hex \
--accept-terms-of-use \
--pprof \
--bootstrap-node="`cat $PANDA/bootstrap_nodes.txt | tr -s '\n' ','`" \
--log-file=${PRYSMRUN}/beacon.log

popd

