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
