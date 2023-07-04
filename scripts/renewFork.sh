#! /bin/bash
echo "***FOUNDRY BLOCKSCOUT RESTART***"

LATEST_BLOCK_HEX=`curl http://localhost:80/api\?module\=block\&action\=eth_block_number | jq .result | tr -d '"' | cut -c 3-` && \
LATEST_BLOCK=`echo $(( 16#$LATEST_BLOCK_HEX ))` && \
FORK_BLOCK=$(($LATEST_BLOCK+1)) && \
echo "Restarting At $FORK_BLOCK"

BLOCK_RANGES="$BASE_RANGE,$FORK_BLOCK..latest"
echo "With Range $BLOCK_RANGES"
FORK_BLOCK=$FORK_BLOCK BLOCK_RANGES=$BLOCK_RANGES docker compose -f $BLOCKSCOUT/docker-compose/docker-compose-anvil.yml up -d

RPC_URL=http://localhost:80/rpc/

echo "Getting mainnet time..." && \
BLOCKTIME=`cast block --rpc-url $MAINNET | grep "timestamp" | grep -Eo '[0-9]{10}'` && \
echo $BLOCKTIME && \
echo "Getting fork time..." && \
FORKTIME=`cast block --rpc-url $RPC_URL | grep "timestamp" | grep -Eo '[0-9]{10}'` && \
echo $FORKTIME && \
cast rpc evm_setNextBlockTimestamp $BLOCKTIME --rpc-url $RPC_URL

exit 0