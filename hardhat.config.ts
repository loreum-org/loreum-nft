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
        auto: true,
        interval: 50000,
      },
      gasPrice: "auto",
    },
    hardhat: {
      allowUnlimitedContractSize: false,
      hardfork: "london", // Berlin is used (temporarily) to avoid issues with coverage
      mining: {
        auto: true,
        interval: 50000,
      },
      gasPrice: "auto",
    },
    goerli: {
      url: process.env.GORELI_RPC_URL || "",
      accounts: [process.env.GOERLI_DEPLOYER_KEY || ""],
    },
  },
  etherscan: {
    apiKey: {
      goerli: process.env.ETHERSCAN_API_KEY || "",
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.8.16",
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
    sources: "./src/",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  abiExporter: {
    path: "./abis",
    runOnCompile: true,
    clear: true,
    flat: true,
    pretty: false,
    except: ["test*", "open-zeppelin*", "uniswap*"],
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
