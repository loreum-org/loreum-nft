// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.19;

import {ERC2981} from "lib/openzeppelin-contracts/contracts/token/common/ERC2981.sol";
import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import {ERC721Enumerable} from "lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Strings} from "lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import {IERC721} from "lib/openzeppelin-contracts/contracts/interfaces/IERC721.sol";
import {IERC721Metadata} from "lib/openzeppelin-contracts/contracts/interfaces/IERC721Metadata.sol";

/// @title The base NFT contract for the Loreum collection.
contract LoreumNFT is ERC2981, ERC721Enumerable, Ownable, ReentrancyGuard {

    // ---------------------
    //    State Variables
    // ---------------------   
    
    uint16 public immutable MAX_SUPPLY;         /// @dev The maximum supply of NFTs mintable.
    string public tokenUri;                     /// @dev Uniform Resource Identifier for the collection.
    
    // -----------------
    //    Constructor
    // -----------------

    /// @notice Initializes the LoreumNFT.sol contract.
    /// @param  name_ The name of this NFT collection.
    /// @param  symbol_ The symbol of this NFT collection.
    /// @param  tokenUri_ The Uniform Resource Identifier for the collection.
    /// @param  maxSupply_ The maximum totalSupply() for this NFT collection.
    /// @param  admin The owner (multi-sig) which receives sales and is responible for managing the mint cost.
    constructor(
        string memory name_,
        string memory symbol_,
        string memory tokenUri_,
        uint mintCost_,
        uint96 royaltyFraction_,
        uint16 maxSupply_,
        uint8 maxMint_,
        address admin
    ) Ownable() ERC721(name_, symbol_) {
        // Initial assignment of state variables.
        tokenUri = tokenUri_;
        MAX_SUPPLY = maxSupply_;
    }


    // ------------
    //    Events
    // ------------

    /// @notice Emitted during publicMint().
    /// @param  mintedBy The address minting the NFT.
    /// @param  tokenId The tokenId of the NFT minted.
    /// @param  cost The cost to mint the NFT.
    event NFTMinted(address indexed mintedBy, uint16 indexed tokenId, uint cost);    

    // ---------------
    //    Functions
    // ---------------

    /// @notice Overrides the supportsInterface function in three base contracts.
    /// @param  interfaceId The interfaceId to check support for.
    function supportsInterface(bytes4 interfaceId) 
        public 
        view 
        override(ERC2981, ERC721Enumerable) 
        returns (bool) 
    {
        return interfaceId == type(IERC721).interfaceId 
            || interfaceId == type(IERC721Metadata).interfaceId 
            || interfaceId == type(IERC721Enumerable).interfaceId 
            || interfaceId == type(IERC2981).interfaceId 
            || super.supportsInterface(interfaceId);
    }

    /// @notice Implements the metadata standard by constructing a unique URI for each token.
    /// @param  tokenId_ The tokenID to view the URI for.
    function tokenURI(uint256 tokenId_) override view public returns (string memory) {
        return string(abi.encodePacked(tokenUri, Strings.toString(tokenId_)));
    }

    /// @notice A public endpoint to mint an NFT, allows for batch minting.
    /// @param  amount The amount of NFTs to mint.
    function publicMint(uint8 amount) external payable nonReentrant {

        require(
            totalSupply() < MAX_SUPPLY && totalSupply() + amount <= MAX_SUPPLY, 
            "LoreumNFT::publicMint() minted >= MAX_SUPPLY || minted + amount > MAX_SUPPLY"
        );
        
        // Increment amount of NFTs minted by _msgSender().
        totalMinted[_msgSender()] += amount;

        // Transfer ETH prior to _mint().
        payable(owner()).transfer(msg.value);
        
        // Mint NFT(s) from the contract, tokenId = totalSupply() + 1 due to sequential nature.
        for (uint8 i = 0; i < amount; i++) {
            _safeMint(_msgSender(), totalSupply() + 1, "");
            emit NFTMinted(_msgSender(), uint16(totalSupply()), mintCost);
        }
    }

    /// @notice Handles arbitrary call() executions to address(this), forwards any msg.value to owner().
    fallback() external payable {
        payable(owner()).transfer(msg.value);
    }

    /// @notice Handles arbitrary direct ETH transfers, forwards the amount to owner().
    receive() external payable {
        payable(owner()).transfer(msg.value);
    }

}
