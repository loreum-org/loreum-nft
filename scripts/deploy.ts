import { ethers } from "hardhat";

async function main() {
  console.log("Deploying NFT Contracts...");

  const admin = ethers.provider.getSigner(1);
  const adminAdr = await admin.getAddress();

  console.log("Admin Address:", adminAdr)

  const name = "LoreumNFT";
  const symbol = "LOREUM";
  const tokenUri = "ipfs://bafybeia4ba2mxk3dzdhu2kaqeh5svu244qmcwbkhm56e2nz4pnuqfake4q/";
  const mintCost = ethers.BigNumber.from("10").pow(16).mul(5)
  const royaltyFraction = 500;
  const maxSupply = 10000;
  const maxMint = 100;

  console.log("Name:", name);
  console.log("Symbol:", symbol);
  console.log("Token URI:", tokenUri);
  console.log("Mint Cost:", ethers.utils.formatEther(mintCost.toString()), "ether");
  console.log("Royalty Fraction:", royaltyFraction);
  console.log("Max Supply:", maxSupply);
  console.log("Max Mint per Wallet:", maxMint);

  const LoreumNFT = await ethers.getContractFactory(name);
  const NFT = await LoreumNFT.deploy(
    name,
    symbol,
    tokenUri,
    mintCost,
    royaltyFraction,
    maxSupply,
    maxMint,
    adminAdr
  );

  await NFT.deployed();
  console.log("NFT Contract:", NFT.address);
}

main()
  .then(() => process.exit())
  .catch((err) => {
    console.error(err);
    return process.exit();
  });
