require("@nomicfoundation/hardhat-toolbox");
//require("@nomiclabs/hardhat-waffle");
// require('@nomiclabs/hardhat-ethers');
//require("@nomiclabs/hardhat-etherscan");
//require("@openzeppelin/hardhat-upgrades");
//require('@nomicfoundation/hardhat-chai-matchers')
require("@nomicfoundation/hardhat-verify");
require('dotenv').config()

const mnemonic = process.env.MNEMONIC;
const TESTNET_ACCOUNT = process.env.TESTNET_ACCOUNT;
const MAINNET_ACCOUNT = process.env.MAINNET_ACCOUNT;
const MULTICHAIN_DEPLOYER = process.env.AJIRA_PAY_MULTICHAIN_DEPLOYER
const BSCSCAN_API_KEY = process.env.BSCSCAN_API_KEY
const POLYGONSCAN_API_KEY = process.env.POLYGONSCAN_API_KEY
const ARBISCAN_API_KEY = process.env.ARBISCAN_API_KEY
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY
const INFURA_API_KEY = process.env.INFURA_API_KEY_V2
const TESTNET_ACCOUNT_V2 = process.env.TESTNET_ACCOUNT_V2
const KAVA_DEPLOYER = process.env.KAVA_DEPLOYER
const CELOSCAN_API_KEY = process.env.CELOSCAN_API_KEY
const LINEASCAN_API_KEY = process.env.LINEASCAN_API_KEY

/** @type import('hardhat/config').HardhatUserConfig */

module.exports = {
  sourcify: {
    enabled: true
  },
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
  
    },
  },
  networks: {
  	localhost: {
      url: "http://127.0.0.1:8545"
    },
    hardhat: {

    },
    bscTestnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      chainId: 97,
      accounts: [MULTICHAIN_DEPLOYER],
      allowUnlimitedContractSize: true
    },
    mainnet:{
      chainId: 1,
      url: `https://mainnet.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [MULTICHAIN_DEPLOYER],
      allowUnlimitedContractSize: true
    },
    bsc: {
      url: "https://bsc-dataseed.binance.org/",
      chainId: 56,
      networkCheckTimeout: 500000000000,
      accounts: [KAVA_DEPLOYER],
    },
    polygon: {
      chainId: 137,
      url: 'https://polygon-rpc.com/',
      accounts: [KAVA_DEPLOYER],
      allowUnlimitedContractSize: true
    },
    kava:{
      chainId: 2222,
      url: 'https://evm.kava.io',
      accounts: [KAVA_DEPLOYER],
      allowUnlimitedContractSize: true
    },
    kavaTestnet:{
      chainId: 2221,
      url: 'https://evm.testnet.kava.io',
      accounts: [KAVA_DEPLOYER],
      allowUnlimitedContractSize: true
    },
    arbitrumOne:{
      chainId: 42161,
      url: `https://arbitrum-mainnet.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [KAVA_DEPLOYER],
      allowUnlimitedContractSize: true
    },
    celo: {
      url: "https://forno.celo.org",
      accounts: [KAVA_DEPLOYER],
      chainId: 42220
      // accounts: {
      //   accounts: [KAVA_DEPLOYER],
      //   //path: "m/44'/52752'/0'/0"
      // },
      // chainId: 42220
    },
    alfajores: {
      url: "https://alfajores-forno.celo-testnet.org",
      accounts: [KAVA_DEPLOYER],
      chainId: 44787,
      // accounts: {
      //   accounts: [KAVA_DEPLOYER],
      //   //path: "m/44'/52752'/0'/0"
      // chainId: 44787
    },
    linea_testnet: {
      url: `https://linea-goerli.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [KAVA_DEPLOYER],
      allowUnlimitedContractSize: true,
      chainId: 59140
    },
    linea_mainnet: {
      url: `https://linea-mainnet.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [KAVA_DEPLOYER],
      allowUnlimitedContractSize: true,
      chainId: 59144
    },
  },
  etherscan: {
    apiKey: {
      mainnet: ETHERSCAN_API_KEY,
      bscTestnet: BSCSCAN_API_KEY,
      bsc: BSCSCAN_API_KEY,
      kava: ETHERSCAN_API_KEY,
      kavaTestnet: ETHERSCAN_API_KEY,
      polygon: POLYGONSCAN_API_KEY,
      arbitrumOne: ARBISCAN_API_KEY,
      alfajores: CELOSCAN_API_KEY,
      celo: CELOSCAN_API_KEY,
      linea_mainnet: LINEASCAN_API_KEY,
      linea_testnet: LINEASCAN_API_KEY
    },
    customChains: [
      {
        network: 'kava',
        chainId: 2222,
        urls: {
          apiURL: 'https://explorer.kava.io/api',
          browserURL: 'https://explorer.kava.io',
        },
      },
      {
        network: 'kavaTestnet',
        chainId: 2221,
        urls: {
          apiURL: 'https://testnet.kavascan.com/api',
          browserURL: 'https://testnet.kavascan.com/'
        },
      },
      {
        network: "linea_mainnet",
        chainId: 59144,
        urls: {
          apiURL: "https://api.lineascan.build/api",
          browserURL: "https://lineascan.build/"
        }
      },
      {
        network: "linea_testnet",
        chainId: 59140,
        urls: {
          apiURL: "https://api-testnet.lineascan.build/api",
          browserURL: "https://goerli.lineascan.build/address"
        }
      }
    ],
  }
};