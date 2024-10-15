require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-verify");


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.26",
  defaultNetwork: "localhost",
  networks: {
    sepolia: {
      url: "https://rpc.sepolia.org",
      accounts: [""]
    },
    local: {
      url: "http://127.0.0.1:8545/",
      chainId: 31337,
      accounts: [
        "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80",
        "0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d",
        "0xea6c44ac03bff858b476bba40716402b03e41b8e97e276d1baec7c37d42484a0"
      ]
    }
  },
  sourcify: {
    enabled: true
  },
  etherscan: {
    apiKey: {
      sepolia: 'SCK9AI7UNQ35EXAG71YEJVQE71YQGFA8US'
    }
  }
};
