#! /bin/bash
echo "***FOUNDRY HEALTH CHECK***"

if ! timeout 5 cast block; then
    echo "Anvil NOK"
    LATEST_BLOCK_HEX=`curl http://localhost:80/api\?module\=block\&action\=eth_block_number | jq .result | tr -d '"' | cut -c 3-` && \
    LATEST_BLOCK=`echo $(( 16#$LATEST_BLOCK_HEX ))` && \
    FORK_BLOCK=$(($LATEST_BLOCK+1)) && \
    echo "Restarting At"
    echo $FORK_BLOCK
    FORK_BLOCK=$FORK_BLOCK docker compose -f $BLOCKSCOUT/docker-compose/docker-compose-anvil.yml up -d
else
    echo "Anvil OK"
fi

exit 0