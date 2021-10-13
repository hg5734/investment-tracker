require("@nomiclabs/hardhat-waffle");

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
  defaultNetwork: "kovan",
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
      accounts: [PK],
      blockNumber: 13319416
    }
  },
  mocha: {
    timeout: 100000
  },
};
