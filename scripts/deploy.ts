import { ethers } from "hardhat";

async function main() {
  console.log("Deploying NFT Contracts...");

  const admin = ethers.provider.getSigner(1);
  const adminAdr = await admin.getAddress();

  const name = "LoreumNFT";
  const symbol = "LOREUM";
  const tokenUri = "ipfs://bafybeia4ba2mxk3dzdhu2kaqeh5svu244qmcwbkhm56e2nz4pnuqfake4q/";
  const mintCost = ethers.BigNumber.from("5").pow(16);
  const royaltyFraction = 500;
  const maxSupply = 10000;
  const maxMint = 100;

  const LoreumNFT = await ethers.getContractFactory(name);
  const params = [name, symbol, tokenUri, mintCost, royaltyFraction, maxSupply, maxMint, adminAdr];
  const NFT = await LoreumNFT.deploy(...params);

  await NFT.deployed();
  console.log(NFT.address);
}

main()
  .then(() => process.exit())
  .catch((err) => {
    console.error(err);
    return process.exit();
  });
