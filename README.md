## Loreum NFT POC

### Setup

1. Copy `.example.env` to `.env`

```
cp .example.env .env
```

2. `yarn` to install npm packages

```
yarn install
```

3. `yarn setup` to clone libs.

```
yarn setup
```

### Foundry

```
forge build
forge test --verbosity -vvv
```

### Hardhat

You'll need to open two terminals.

_Terminal 1_

```
yarn chain
```

_Terminal 2_

```
yarn compile
yarn deploy:local
yarn cycle
```

## Verify 

npx hardhat verify --network goerli 0xCA993ad15300Eba7d8351a361582B81dbC02e025 Blackholes HOLES ipfs://QmV2GaNKyngHThr7pbnVAg8YnT9e8Nuo6WSiAAPhtVcAs8/ 5000000000000000 500 100 100 0xA9bF0E34859870cF14102dC6894a7B2AC3ceDf83

  name,
  symbol,
  tokenUri,
  mintCost,
  royaltyFraction,
  maxSupply,
  maxMint,
  adminAddress