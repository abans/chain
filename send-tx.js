import {ethers} from 'ethers'
import Web3 from 'web3'

// 你的本地 Polygon Edge 节点
const RPC_URL = 'http://192.168.31.36:8545'

// 私钥（比如 genesis 或 validator 节点的）

// const keyJson =
//   '{"address":"2bb462871dce82bcb8f7e3f001b00c6c2e6b9e7c","crypto":{"cipher":"aes-128-ctr","ciphertext":"ebbf594ed5321ab53a0fe54eeada52d6717423d917a01c4fcac20c3177bbef28","cipherparams":{"iv":"f66ed2fb91e37f4027551a1489a75e02"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":4096,"p":6,"r":8,"salt":"7adf88907717d7490d22c923899c29873555519c4ca4076f022c06bf39ef748e"},"mac":"15676fa8c4a46a37f807117ed26f81360670e1336876d07a4ed46d4f99360c7a"},"id":"2c8de98b-7ade-40e9-8762-3c9215366496","version":3}'

// const rs = await ethers.Wallet.fromEncryptedJson(keyJson, '')
const PRIVATE_KEY = '0xddbba9beffd5b13411d9e16669d3ebde138c83807e75c88eb9ba2fbcd04ca209' // || rs.privateKey // 填你自己的私钥
const TO_ADDRESS = '0x6c73A7B6A4F925b699908a4bae4aA40D0f6124Ad' // 收款地址

async function main() {
  const web3 = new Web3('http://192.168.31.36:8545')
  const from = '0x2bB462871dCE82bcB8F7E3F001b00c6C2E6b9E7c' // 创世账户
  const to = TO_ADDRESS // 接收地址
  const privateKey = PRIVATE_KEY // 创世账户私钥
  const nonce = await web3.eth.getTransactionCount(from)
  ;(async () => {
    const tx = {
      from,
      to,
      value: web3.utils.toWei('0.0032', 'ether'),
      gas: 21000,
      gasPrice: 10000,
      nonce,
    }

    const signed = await web3.eth.accounts.signTransaction(tx, privateKey)
    console.log(signed)
    const receipt = await web3.eth.sendSignedTransaction(signed.rawTransaction)
    console.log(receipt)
  })()
}

main().catch(console.error)
