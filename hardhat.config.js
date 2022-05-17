// hardhat.config.js
require('@nomiclabs/hardhat-ethers');
require('@openzeppelin/hardhat-upgrades');

module.exports = {
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    }
  },
  networks: {
    prod: {
      url: "https://babel-api.mainnet.iotex.io",
      accounts: [''],
      chainId: 4689,
      gas: 8500000,
      gasPrice: 1000000000000
    },
    dev: {
      url: "https://babel-api.testnet.iotex.io",
      accounts: [''],
      chainId: 4690,
      gas: 1000000,
      gasPrice: 1000000000000
    },
  },
};