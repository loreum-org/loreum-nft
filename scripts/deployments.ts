import { ethers } from 'ethers'

export const localhost = {
  LoreumNFT: "0x5FbDB2315678afecb367f032d93F642f64180aa3",
  name: "Blackholes",
  symbol: "HOLES",
  tokenUri: "ipfs://QmdmSzXAHnQW2ufFp9eApwb1HQQkrZAAnZqtzfb9bbXVqn/",
  mintCost: ethers.BigNumber.from("10").pow(16).mul(5),
  royaltyFraction: 500,
  maxSupply: 100,
  maxMint: 100,
  adminAddress: "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
};

export const goerli = {
  LoreumNFT: "0x2b1f4f3ddc5689967Efa315d28ACb9da7582A3B7",
  name: "Blackholes",
  symbol: "HOLES",
  tokenUri: "ipfs://QmdmSzXAHnQW2ufFp9eApwb1HQQkrZAAnZqtzfb9bbXVqn/",
  mintCost: ethers.BigNumber.from("10").pow(16).mul(5),
  royaltyFraction: 500,
  maxSupply: 100,
  maxMint: 100,
  adminAddress: "0xA9bF0E34859870cF14102dC6894a7B2AC3ceDf83"
}

export const mainnet = {
  LoreumNFT: "",
  name: "Loreum Explorers",
  symbol: "LOREUM",
  tokenUri: "ipfs://Qmf1rhNDzgcam4pkctyaekCZNUXf47Ngmwzmci52wdpV8S/",
  mintCost: ethers.BigNumber.from("10").pow(16).mul(5),
  royaltyFraction: 500,
  maxSupply: 10000,
  maxMint: 100,
  adminAddress: "0xA9bF0E34859870cF14102dC6894a7B2AC3ceDf83" 
}
