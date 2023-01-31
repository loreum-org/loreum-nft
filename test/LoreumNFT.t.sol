// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.16;

// Utility import.
import "test/utilities/Utility.sol";

// NFT contract import(s).
import "src/LoreumNFT.sol";
 
contract LoreumNFTTest is Utility {

    LoreumNFT NFT;

    // Initial NFT settings.
    string public name = "LoreumNFT";
    string public symbol = "LOREUM";
    string public tokenUri = "ipfs://bafybeia4ba2mxk3dzdhu2kaqeh5svu244qmcwbkhm56e2nz4pnuqfake4q/";

    uint public mintCost = 0.05 ether;
    uint96 public royaltyFraction = 500;  // 5%
    uint16 public maxSupply = 10000;
    uint8 public maxMint = 5;

    address admin;      /// @dev Defined in the setUp() function.



    // Initial setUp() function, runs before every test_*.
    function setUp() public {
        
        // Create actors and tokens.
        deployCore();
        
        // Fund "tom" for minting expenses.
        payable(address(tom)).transfer(100 ether);

        // We define this variable here after deployCore() 
        // in order to instantiate the actor "god".
        admin = address(god);

        NFT = new LoreumNFT(
            name, 
            symbol,
            tokenUri,
            mintCost,
            royaltyFraction,
            maxSupply,
            maxMint,
            admin
        );

    }

    // Validate NFT contract constructor() and deployment.
    function test_LoreumNFT_initial_state(uint16 _uri) public {

        // Initial constructor() parameters.
        assertEq(NFT.name(), name);
        assertEq(NFT.symbol(), symbol);
        assertEq(NFT.tokenUri(), "ipfs://bafybeia4ba2mxk3dzdhu2kaqeh5svu244qmcwbkhm56e2nz4pnuqfake4q/");
        assertEq(NFT.MAX_SUPPLY(), maxSupply);
        assertEq(NFT.MAX_MINT(), maxMint);
        assertEq(NFT.owner(), admin);
        assertEq(NFT.mintCost(), 0.05 ether);

        // Native endpoints.
        assertEq(NFT.tokenURI(_uri), string(abi.encodePacked(NFT.tokenUri(), Strings.toString(_uri))));
        assertEq(NFT.totalSupply(), 0);
        assertEq(NFT.balanceOf(address(this)), 0);

        // Supports interfaces check.
        assert(NFT.supportsInterface(type(IERC721).interfaceId));
        assert(NFT.supportsInterface(type(IERC721Metadata).interfaceId));
        assert(NFT.supportsInterface(type(IERC721Enumerable).interfaceId));
        assert(NFT.supportsInterface(type(IERC2981).interfaceId));
    }
    
    // Validate publicMint() state changes.
    function test_publicMint_state(uint8 amountToMint) public {

        uint8 mintThisMuch = amountToMint % 5 + 1;

        // Pre-state.
        uint preBalanceMinter = address(tom).balance;
        uint preBalanceOwner = address(NFT.owner()).balance;


        // publicMint().
        tom.try_publicMint(address(NFT), mintThisMuch, NFT.mintCost());


        // Post-state.
        uint postBalanceMinter = address(tom).balance;
        uint postBalanceOwner = address(NFT.owner()).balance;

        assertEq(preBalanceMinter - postBalanceMinter, NFT.mintCost() * mintThisMuch);
        assertEq(postBalanceOwner - preBalanceOwner, NFT.mintCost() * mintThisMuch);
        assertEq(NFT.totalSupply(), mintThisMuch);
        assertEq(NFT.balanceOf(address(tom)), mintThisMuch);

        for (uint8 b = 0; b < mintThisMuch; b++) {
            assertEq(NFT.ownerOf(b + 1), address(tom));
        }
    }

    // Validate updateMintCost() state changes.
    function test_updateMintCost_state_changes(uint256 newCost) public {

        // updateMintCost().
        assert(god.try_updateMintCost(address(NFT), newCost));

        // Post-state.
        assertEq(NFT.mintCost(), newCost);
    }

    // Validate updateMintCost() restrictions.
    function test_updateMintCost_restrictions(uint256 newCost) public {
        assert(!ass.try_updateMintCost(address(NFT), newCost));
    }

    // TODO: Validate publicMint() restrictions.

    // function test_publicMint_state_full() public {

    //     for (uint i = 0; i < NFT.MAX_SUPPLY(); i++) {
    //         tom.try_publicMint(address(NFT), 1, NFT.mintCost());
    //     }

    //     uint numberMinted = minter.minted();
    //     for (uint i = 0; i < maxSupply; i++) {
    //         if (numberMinted >= maxSupply) {
    //             hevm.expectRevert("Minter::publicMint() minted > MAX_SUPPLY || minted + amount > MAX_SUPPLY");
    //             minter.publicMint{value: 0.05 ether}(1);
    //         } else {
    //             minter.publicMint{value: 0.05 ether}(1);
    //         }
    //         numberMinted = minter.minted();
    //     }
    //     assertEq(minter.minted(), minter.MAX_SUPPLY());
    // }
}
