#! /usr/bin/env bash
# set +x
 set -e

#export GOTRACEBACK=crash

ETHENVS=/home/kasey/src/kasey/eth-envs/mainnet
ENVRUN=/var/lib/eth/mainnet
PRYSMSRC=$HOME/src/prysmaticlabs/prysm
PRYSMRUN=$ENVRUN/prysm
CPURL=https://sync-mainnet.beaconcha.in

# prysm will automatically make the directory, but not before the logger fails to init the log file.
# so manually make the dir for clean logging.
mkdir -p $PRYSMRUN

pushd $PRYSMSRC

bazel build //cmd/beacon-chain -c dbg

CPFLAGS=""
if [ "$1" = "checkpoint" ]; then
	CPFLAGS="--checkpoint-sync-url=${CPURL} --genesis-beacon-api-url=${CPURL} --enable-experimental-backfill"
	#CPFLAGS="--checkpoint-sync-url=${CPURL} --genesis-beacon-api-url=${CPURL}"
fi

$PRYSMSRC/bazel-bin/cmd/beacon-chain/beacon-chain_/beacon-chain ${CPFLAGS} \
--verbosity=debug \
--execution-endpoint=http://localhost:8551 \
--datadir=${PRYSMRUN} \
--enable-debug-rpc-endpoints \
--grpc-max-msg-size=65568081 \
--jwt-secret=${ETHENVS}/jwt.hex \
--accept-terms-of-use \
--pprof \
--log-file=${PRYSMRUN}/beacon.log
#--backfill-oldest-slot=0 \
#--backfill-worker-count=1 \
#--backfill-batch-size=32 \

popd

