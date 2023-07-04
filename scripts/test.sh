#! /bin/bash
echo "***FOUNDRY BLOCKSCOUT RESTART***"

BLOCKNUMBER=`cast block --rpc-url $MAINNET | grep "number" | grep -Eo '[0-9]{8}'` && \
echo $BLOCKNUMBER && \
FORK_BLOCK=$(($BLOCKNUMBER + 1)) && \
echo "BLOCK $BLOCKNUMBER" && \
echo "FORK $FORK_BLOCK" && 
BLOCK_RANGES="$BASE_RANGE,$FORK_BLOCK..latest"
echo "With Range $BLOCK_RANGES"

exit 0