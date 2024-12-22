# Loreum Explorers NFT

## Overview

Loreum Explorers is an ERC-721 compliant Non-Fungible Token (NFT) collection deployed on the Ethereum blockchain. The collection features unique digital assets that represent explorers in the Loreum universe. Each token is distinct and can be owned, transferred, and traded by users.

## Contract Details

- **Contract Name:** Explorers
- **Token Name:** Loreum Explorers
- **Token Symbol:** LOREXP
- **Max Supply:** 10,000
- **Mint Cost:** 0.05 ETH
- **Base URI:** [ipfs://QmcTBMUiaDQTCt3KT3JLadwKMcBGKTYtiuhopTUafo1h9L/](ipfs://QmcTBMUiaDQTCt3KT3JLadwKMcBGKTYtiuhopTUafo1h9L/)


## Image and Attribute Generation

Each Loreum Explorer NFT is unique and features an image created by Dall-e stable diffusion in 2022. The images are stored on IPFS and can be accessed using the base URI followed by the token ID.

### Attribute Derivation

The attributes of each NFT are derived using a k-means clustering algorithm on the pixel colors of the image. The algorithm identifies the 5 dominant colors in the image, and these colors are used to assign attributes to the NFT. This process ensures that each NFT is random and unique.

Here is an example of the metadata for a Loreum Explorer NFT:

```
{
  "name": "Loreum Explorer #70",
  "tokenId": "70",
  "image": "ipfs://QmfPWZ6VuFyLqTY92RRCCGRQxUKAhBAHs4vJb7wCT15hZr/70",
  "attributes": [
    {
      "trait_type": "Virtue",
      "value": "Wisdom",
      "hex": "49738b",
      "weight": "0.3294"
    },
    {
      "trait_type": "Vice",
      "value": "Impulsivity",
      "hex": "9a4d33",
      "weight": "0.2761"
    },
    {
      "trait_type": "Motive",
      "value": "Adventure",
      "hex": "f3e2d0",
      "weight": "0.1841"
    },
    {
      "trait_type": "Calling",
      "value": "Scientist",
      "hex": "162b47",
      "weight": "0.1172"
    },
    {
      "trait_type": "Expertise",
      "value": "Meteorology",
      "hex": "e8a57c",
      "weight": "0.0932"
    }
  ]
}
```

### Weight Calculation Using K-Means

The weight of each attribute is determined by the k-means clustering algorithm during the attribute derivation process. Here's how it works:

1. **Image Processing:** The image of the NFT is processed to extract pixel color data.
2. **Clustering:** The k-means algorithm is applied to the pixel color data to identify the 5 dominant colors in the image. Each color represents a cluster.
3. **Cluster Weights:** The weight of each attribute is calculated based on the proportion of pixels that belong to each cluster. For example, if a cluster contains 32.94% of the pixels, the corresponding attribute will have a weight of 0.3294.
4. **Attribute Assignment:** The dominant colors and their weights are then used to assign attributes to the NFT, ensuring that each NFT is unique and its attributes are derived from its image.

This process ensures that the attributes of each NFT are not only unique but also visually representative of the image associated with the NFT.

## Features

- **Minting:** Users can mint new NFTs by paying the mint cost. The minting process is secured with a reentrancy guard to prevent attacks.
- **Migration:** The contract supports migration of NFTs from the mainnet to the Base network.
- **Ownership:** The contract includes ownership management, allowing the owner to transfer ownership and manage the contract.
- **Fallback and Receive Functions:** The contract can handle direct ETH transfers and arbitrary call executions, forwarding any received ETH to the owner.

## Functions

### Public Functions

- **mint():** Allows users to mint a new NFT by paying the mint cost.
- **supportsInterface(bytes4 interfaceId):** Checks if the contract supports a given interface.

### Owner-Only Functions

- **migrate(address[] memory owners, uint256[] memory tokenIds):** Allows the owner to migrate NFTs to the Base network.
- **transferOwnership(address newOwner):** Transfers ownership of the contract to a new owner.

### Internal Functions

- **_baseURI():** Returns the base URI for computing token URIs.

## Events

- **Minted(address indexed owner, uint256 indexed tokenId):** Emitted when a new NFT is minted.

## Errors

- **InvalidMigration(address owner, uint256 tokenId):** Thrown when an invalid migration is attempted.
- **MaxSupply():** Thrown when the max supply of NFTs is reached.
- **MintCost():** Thrown when the mint cost is not met.
- **UnknownId():** Thrown when an unknown token ID is referenced.
- **LengthMismatch():** Thrown when the lengths of input arrays do not match during migration.

## Deployment

The contract is deployed using the `DeployExplorers` script, which initializes the contract with the following parameters:
- **Owner:** 0x61ED082106cF5DF1b05Eb0D67216B3F73CbA2DB4
- **Max Supply:** 10,000
- **Mint Cost:** 0.05 ETH
- **Base URI:** ipfs://QmcTBMUiaDQTCt3KT3JLadwKMcBGKTYtiuhopTUafo1h9L/
- **Name:** Loreum Explorers
- **Symbol:** LOREXP

## Testing

The contract is thoroughly tested using the `ExplorersTest` suite, which includes tests for minting, interface support, token URI generation, fallback and receive functions, and migration.

## License

This project is licensed under the MIT License.

For more details, refer to the source code and documentation.




Blackholes HOLES ipfs://QmV2GaNKyngHThr7pbnVAg8YnT9e8Nuo6WSiAAPhtVcAs8/ 

Loreum Explorers LOREUM ipfs://QmcTBMUiaDQTCt3KT3JLadwKMcBGKTYtiuhopTUafo1h9L/ 