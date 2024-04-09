#! /usr/bin/env bash
# set +x
set -e

ETHENVS=/home/kasey/src/kasey/eth-envs/holesky
ENVRUN=/var/lib/db/holesky
CFG=$HOME/src/eth-clients/holesky/custom_config_data
PRYSMSRC=$HOME/src/prysmaticlabs/prysm
PRYSMRUN=$ENVRUN/prysm
CPURL=https://checkpoint-sync.holesky.ethpandaops.io

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

# Note! boostrap-node hand-edited from bootstrap_nodes.txt in $CFG dir
$PRYSMSRC/bazel-bin/cmd/beacon-chain/beacon-chain_/beacon-chain ${CPFLAGS} \
--genesis-state=${CFG}/genesis.ssz \
--chain-config-file=${CFG}/config.yaml \
--min-sync-peers=1 \
--verbosity=debug \
--bootstrap-node=enr:-Ku4QFmUkNp0g9bsLX2PfVeIyT-9WO-PZlrqZBNtEyofOOfLMScDjaTzGxIb1Ns9Wo5Pm_8nlq-SZwcQfTH2cgO-s88Bh2F0dG5ldHOIAAAAAAAAAACEZXRoMpDkvpOTAAAQIP__________gmlkgnY0gmlwhBLf22SJc2VjcDI1NmsxoQLV_jMOIxKbjHFKgrkFvwDvpexo6Nd58TK5k7ss4Vt0IoN1ZHCCG1g \
--execution-endpoint=http://localhost:8551 \
--datadir=${PRYSMRUN} \
--enable-debug-rpc-endpoints \
--grpc-max-msg-size=65568081 \
--jwt-secret=${ETHENVS}/jwt.hex \
--accept-terms-of-use \
--pprof \
--log-file=${PRYSMRUN}/beacon.log

popd

