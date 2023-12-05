#! /bin/bash
echo "***FOUNDRY BLOCKSCOUT RESTART***"

echo "Checking Blockscout..."
if LATEST_BLOCK_BLOCKSCOUT=$(curl http://localhost:80/api\?module\=block\&action\=eth_block_number);
then
    LATEST_BLOCK_HEX=`echo $LATEST_BLOCK_BLOCKSCOUT | jq .result | tr -d '"' | cut -c 3-` && \
    export FORK_BLOCK=`echo $(( 16#$LATEST_BLOCK_HEX ))`
else
    echo "Blockscout NOK, getting mainnet block"
    export FORK_BLOCK=`cast block --rpc-url $MAINNET | grep "number" | grep -Eo '[0-9]{8}'`
fi
echo "Restarting At $FORK_BLOCK" && \

INDEX_BLOCK=$(($FORK_BLOCK + 1)) && \
echo "Indexing At $INDEX_BLOCK" && \
export BLOCK_RANGES="$BASE_RANGE,$INDEX_BLOCK..latest";
echo "With Range $BLOCK_RANGES" && \
docker compose -f $BLOCKSCOUT/docker-compose/docker-compose-anvil.yml up -d && \

RPC_URL=http://localhost:80/rpc/ && \

echo "Getting mainnet time..." && \
BLOCKTIME=`cast block --rpc-url $MAINNET | grep "timestamp" | grep -Eo '[0-9]{10}'` && \
echo $BLOCKTIME && \
echo "Getting fork time..." && \
FORKTIME=`cast block --rpc-url $RPC_URL | grep "timestamp" | grep -Eo '[0-9]{10}'` && \
echo $FORKTIME && \
cast rpc evm_setNextBlockTimestamp $BLOCKTIME --rpc-url $RPC_URL

exit 0
