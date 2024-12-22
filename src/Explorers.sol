// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import {ERC721Enumerable} from "lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Strings} from "lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import {IERC721} from "lib/openzeppelin-contracts/contracts/interfaces/IERC721.sol";
import {IERC721Metadata} from "lib/openzeppelin-contracts/contracts/interfaces/IERC721Metadata.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {IERC721Enumerable} from "lib/openzeppelin-contracts/contracts/interfaces/IERC721Enumerable.sol";
import {Constants} from "script/Constants.sol";

/// @title The base NFT contract for the Loreum Explorers collection.
contract Explorers is ERC721Enumerable, Ownable, ReentrancyGuard {
    uint256 public immutable MAX_SUPPLY;
    uint256 public immutable MINT_COST;

    string private BASE_URI;

    event Minted(address indexed owner, uint256 indexed tokenId);

    error InvalidMigration(address owner, uint256 tokenId);
    error MaxSupply();
    error MintCost();
    error UnknownId();
    error LengthMismatch();

    /// @notice Initializes the Explorers.sol contract.
    /// @param owner_ The owner and admin.
    constructor(
        address owner_,
        uint256 maxSupply_,
        uint256 mintCost_,
        string memory baseUri_,
        string memory name_,
        string memory symbol_
    ) Ownable(owner_) ERC721(name_, symbol_) {
        transferOwnership(owner_);
        MAX_SUPPLY = maxSupply_;
        MINT_COST = mintCost_;
        BASE_URI = baseUri_;
    }

    function _baseURI() internal view override returns (string memory) {
        return BASE_URI;
    }

    /// @notice Overrides the supportsInterface function in three base contracts.
    /// @param  interfaceId The interfaceId to check support for.
    function supportsInterface(bytes4 interfaceId) public view override(ERC721Enumerable) returns (bool) {
        return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId
            || interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
    }

    /// @notice A public endpoint to mint an NFT
    function mint() external payable nonReentrant {
        uint256 _totalSupply = totalSupply();

        if (msg.value != MINT_COST) revert MintCost();
        if (_totalSupply >= MAX_SUPPLY) revert MaxSupply();

        (bool sent,) = payable(owner()).call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        address sender = _msgSender();

        _safeMint(sender, _totalSupply + 1, "");
        emit Minted(sender, _totalSupply + 1);
    }

    /// @notice This contract is for migrating and managing Mainnet NFTs.
    /// @dev This is used to migrate mainnet NFTs to Base.
    function migrate(address[] memory owners, uint256[] memory tokenIds) public onlyOwner {
        uint256 length = owners.length;

        if (length != tokenIds.length) {
            revert LengthMismatch();
        }

        for (uint256 i = 0; i < length; i++) {
            if (_ownerOf(tokenIds[i]) != address(0)) {
                revert InvalidMigration(owners[i], tokenIds[i]);
            }

            if (tokenIds[i] > MAX_SUPPLY) {
                revert MaxSupply();
            }

            _safeMint(owners[i], tokenIds[i], "");
            emit Minted(owners[i], tokenIds[i]);
        }
    }

    /// @notice Handles arbitrary call() executions to address(this), forwards any msg.value to owner().
    fallback() external payable {
        (bool sent,) = payable(owner()).call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }

    /// @notice Handles arbitrary direct ETH transfers, forwards the amount to owner().
    receive() external payable {
        (bool sent,) = payable(owner()).call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}
