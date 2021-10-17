require("@nomiclabs/hardhat-waffle");
require('hardhat-deploy');
require("@nomiclabs/hardhat-web3");
require("hardhat-gas-reporter");

require('dotenv').config();

let { PROVIDER_KEY, PK } = process.env;


module.exports = {
  solidity: {
    version: '0.8.3',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  // defaultNetwork: "hardhat",
  networks: {
    development: {
      url: 'http://127.0.0.1:8545'
    },
    kovan: {
      url: `https://kovan.infura.io/v3/${process.env.PROVIDER_KEY}`,
      accounts: [PK]
    },
    forking: {
      url: `https://mainnet.infura.io/v3/${process.env.PROVIDER_KEY}`,
      blockNumber: 13393098
    }
  },
  namedAccounts: {
    deployer: 0,
  },
  mocha: {
    timeout: 100000
  }
};
