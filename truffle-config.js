
// require("dotenv").config();
// const { MNEMONIC, PROJECT_ID } = process.env;

const HDWalletProvider = require("@truffle/hdwallet-provider");
module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    goerli: {
      provider: () =>
        new HDWalletProvider(
          'first cupboard issue route fever family habit dinner junior affair goose layer',
          `https://goerli.infura.io/v3/827967574a6e4aaeb4e2a5efb5c81c77`
        ),
      network_id: 5, // Goerli's id
      confirmations: 2, // # of confirmations to wait between deployments. (default: 0)
      timeoutBlocks: 200, // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true, // Skip dry run before migrations? (default: false for public nets )
    },
  },
  compilers: {
    solc: {
      version: '0.8.17',
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
};
