curl -X POST https://127.0.0.1:8545 \
 -H "Content-Type: application/json" \
 -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
curl -X POST https://192.168.31.36:487/rpc \
 -H "Content-Type: application/json" \
 -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'

生成或准备一个以太坊格式地址​
./polygon-edge secrets generate --name reward --dir ./reward-wallet

./polygon-edge genesis --consensus polybft --block-gas-limit 10000000 --reward-wallet 0x3B418f58C48A0dbc32EeA19Bf6baB799040a7182 --validators 0x0000000000000000000000000000000000001000:0x0000000000000000000000000000000000001001 --premine 0x3B418f58C48A0dbc32EeA19Bf6baB799040a7182:1000000000000000000 --epoch-size 50 --block-time 2s

./polygon-edge genesis --consensus ibft --chain-id 12345 --block-gas-limit 10000000 --name "BncChain"

## 一键启动

- polygon-edge项目启动命令
  ./cluster polybft --docker
- 停止
  ./cluster polybft --docker stop
  ./cluster polybft --docker destroy

- 如何设置 Block Reward
  test indicates whether rootchain contracts deployer is hardcoded test account (otherwise provided secrets are used to resolve deployer account)

## 生成账户并获取私钥

./polygon-edge secrets init --insecure --data-dir ./data

[SECRETS INIT]
Public key (address) = 0x0307eB7e49D0446fE4c1AaBEaA5e6842432DE413
BLS Public key = 0xb13f5e8b6b92f68692e874aed2541a749574bbeabc17c8563c08394f00396b45de541e9bfab70d36831cc1c539158deb
Node ID = 16Uiu2HAmBStB9vmTSHVTazF56Sbkx8fFbE7SHZR6ekzqiQ2c61hJ

sudo ./polygon-edge polybft stake-manager-deploy \
 --jsonrpc http://192.168.31.36:8545 \
 --genesis /var/lib/docker/volumes/local_data/\_data/genesis.json \
 --proxy-contracts-admin 0x5aaeb6053f3e94c9b9a09f33669435e7ef1beaed \
--test

docker logs -f --tail 30 polygon-edge-rootchain
docker logs -f --tail 30 polygon-edge-bootstrapper
docker cp polygon-edge-rootchain:/usr/local/bin/geth ./geth

docker stop polygon-edge-rootchain
docker run -it ghcr.io/0xpolygon/go-ethereum-console:latest sh
geth --datadir /var/lib/docker/volumes/local_eth1data/\_data --unlock 0x228466F2C715CbEC05dEAbfAc040ce3619d7CF0B

echo "s2n3&n9%Z921342" > .password
rm -fr eth1data
./geth --datadir ./eth1data account new --password .password
./geth --datadir ./eth1data account list

<!-- ./geth --datadir ./eth1data --networkid 20555 --unlock 0xF268d55Eb4a6B7B9E6259fB2A0ac5f6e23488726 --password .password -->
