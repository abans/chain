#/bin/sh

admin=0x3B418f58C48A0dbc32EeA19Bf6baB799040a7182

function initIbftConsensus() {
  echo "Running with ibft consensus"
  ./polygon-edge secrets init --insecure --data-dir test-chain- --num 4
  address1=$(./polygon-edge secrets output --data-dir test-chain-1 | grep address | head -n 1 | awk -F ' ' '{print $5}')
  node1_id=$(./polygon-edge secrets output --data-dir test-chain-1 | grep Node | head -n 1 | awk -F ' ' '{print $4}')
  node2_id=$(./polygon-edge secrets output --data-dir test-chain-2 | grep Node | head -n 1 | awk -F ' ' '{print $4}')

  genesis_params="--consensus ibft --validators-prefix test-chain- \
    --bootnode /dns4/node1/tcp/1478/p2p/$node1_id \
    --bootnode /dns4/node2/tcp/1478/p2p/$node2_id"
    # --bootnode /ip4/127.0.0.1/tcp/30301/p2p/$node1_id \
    # --bootnode /ip4/127.0.0.1/tcp/30302/p2p/$node2_id"
}


function createGenesis() {
  ./polygon-edge genesis $genesis_params \
    --block-gas-limit 10000000 \
    --premine $admin:1000000000000000000000 \
    --premine 0x0000000000000000000000000000000000000000 \
    --epoch-size 10 \
    --reward-wallet 0xDEADBEEF:1000000000000000000 \
    --native-token-config "Acans:ACAN:18:true:$address1" \
    --burn-contract 0:0x0000000000000000000000000000000000000000 \
    --epoch-reward 100000000000000000 \
    --chain-id 20555 \
    --name polygon-acans \
    --proxy-contracts-admin $admin
}

function startNodes() {
  if [ "$2" == "write-logs" ]; then
    echo "Writing validators logs to the files..."
  fi

  for i in {1..4}; do
    data_dir="./test-chain-$i"
    grpc_port=$((10000 * $i))
    libp2p_port=$((30300 + $i))
    jsonrpc_port=$((10000 * $i + 2))

    log_file="./validator-$i.log"

    relayer_arg=""
    # Start relayer only if running polybft and for the 1st node
    if [ "$1" == "polybft" ] && [ $i -eq 1 ]; then
      relayer_arg="--relayer"
    fi

    if [ "$2" == "write-logs" ]; then
      if [ ! -f "$log_file" ]; then
        touch "$log_file"
      fi

      ./polygon-edge server --data-dir "$data_dir" --chain genesis.json \
        --grpc-address ":$grpc_port" --libp2p ":$libp2p_port" --jsonrpc ":$jsonrpc_port" \
        --num-block-confirmations 2 $relayer_arg \
        --log-level DEBUG 2>&1 | tee $log_file &
    else
      ./polygon-edge server --data-dir "$data_dir" --chain genesis.json \
        --grpc-address ":$grpc_port" --libp2p ":$libp2p_port" --jsonrpc ":$jsonrpc_port" \
        --num-block-confirmations 2 $relayer_arg \
        --log-level DEBUG &
    fi

  done

  wait
}

# rm genesis.json
# rm -fr data

rm -rf test-chain-*
rm -f genesis.json
initIbftConsensus
# Create genesis file and start the server from binary
createGenesis
startNodes
exit 0