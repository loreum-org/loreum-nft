import type { HardhatUserConfig } from "hardhat/types";
import fs from "fs";

import "@nomiclabs/hardhat-etherscan";
import "@typechain/hardhat";
import "hardhat-abi-exporter";
import "@nomiclabs/hardhat-ethers";
import "hardhat-preprocessor";
import "dotenv/config";


const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  networks: {
    localhost: {
      allowUnlimitedContractSize: false,
      hardfork: "london", // Berlin is used (temporarily) to avoid issues with coverage
      mining: {
        // mempool: {
        //   order: "fifo"
        // },
        auto: true,
        interval: 50000,
      },
      gasPrice: "auto",
    },
    hardhat: {
      allowUnlimitedContractSize: false,
      hardfork: "london", // Berlin is used (temporarily) to avoid issues with coverage
      mining: {
        mempool: {
          order: "fifo"
        },
        auto: true,
        interval: 50000,
      },
      forking: {
        url: process.env.MAINNET_RPC_URL || "",
      },
      gasPrice: "auto",
    },
    sepolia: {
      url: "https://rpc.ankr.com/eth_sepolia",
      accounts: [process.env.SEPOLIA_DEPLOYER_KEY as string ?? 'SEPOLIA_DEPLOYER_KEY'],
    },
    mainnet: {
      url: "https://rpc.ankr.com/eth",
      accounts: [process.env.MAINNET_DEPLOYER_KEY as string ?? 'MAINNET_DEPLOYER_KEY'],
    },
  },
  etherscan: {
    apiKey: {
      sepolia: process.env.ETHERSCAN_API_KEY as string ?? 'ETHERSCAN_API_KEY',
      mainnet: process.env.ETHERSCAN_API_KEY as string ?? 'ETHERSCAN_API_KEY',
    },
  },
  typechain: {
    outDir: "typechain",
    target: "ethers-v5",
  },
  solidity: {
    compilers: [
      {
        version: "0.8.19",
        settings: { optimizer: { enabled: true, runs: 88888 } },
      },
      {
        version: "0.8.13",
        settings: { optimizer: { enabled: true, runs: 88888 } },
      },
      {
        version: "0.7.0",
        settings: { optimizer: { enabled: true, runs: 88888 } },
      },
    ],
  },
  preprocess: {
    eachLine: () => ({
      transform: (line: string) => {
        if (line.match(/^\s*import /i)) {
          for (const [from, to] of getRemappings()) {
            if (line.includes(from)) {
              line = line.replace(from, to);
              break;
            }
          }
        }
        return line;
      },
    }),
  },
  paths: {
    sources: "./contracts",
    tests: "./tests",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  abiExporter: {
    path: "./abis",
    runOnCompile: true,
    clear: true,
    flat: true,
    pretty: false,
    except: ["tests*", "openzeppelin-contracts*"],
  },
};

function getRemappings() {
  return fs
    .readFileSync("remappings.txt", "utf8")
    .split("\n")
    .filter(Boolean) // remove empty lines
    .map((line) => line.trim().split("="));
}


export default config;
