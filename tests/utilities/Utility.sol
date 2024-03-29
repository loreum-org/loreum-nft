// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.19;

// User imports.
import "./actors/Admin.sol";
import "./actors/Blackhat.sol";
import "./actors/Minter.sol";

// Test (foundry-rs) imports.
import "forge-std/src/Test.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

// Interface imports.
interface Hevm {
    function warp(uint256) external;
    function store(address,bytes32,bytes32) external;
    function expectRevert(bytes calldata) external;
    function prank(address) external;
    function startPrank(address) external;
    function stopPrank() external;
}

interface User {
    function approve(address, uint256) external;
}


/// @notice This is the primary Utility contract for testing and debugging.
contract Utility is DSTest, Test {

    Hevm hevm;      /// @dev The core import of Hevm from Test.sol to support simulations.


    // ------------
    //    Actors
    // ------------

    Admin       god;    /// @dev    Represents an administrator of the system.

    Blackhat    ass;    /// @dev    Ass is a malicious actor attempting to break the system.

    Minter      tom;    /// @dev    Tom is a minter, minting NFTs.



    // --------------------------------
    //    Mainnet Contract Addresses   
    // --------------------------------

    /// @notice Stablecoin contracts.
    address constant DAI   = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address constant FRAX  = 0x853d955aCEf822Db058eb8505911ED77F175b99e;
    address constant TUSD  = 0x0000000000085d4780B73119b644AE5ecd22b376;    /// TrueUSD.
    address constant USDC  = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;    
    address constant USDT  = 0xdAC17F958D2ee523a2206206994597C13D831ec7;    /// Tether.

    /// @notice Non-stablecoin contracts.
    address constant WETH  = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;    /// WrappedETH.
    address constant WBTC  = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;    /// WrappedBTC.

    /// @notice Important users.
    address constant BONES = 0x0C6F86b338417B3b7FCB9B344DECC51d072919c9;


    // ---------------
    //    Constants
    // ---------------

    uint256 constant BIPS = 10 ** 4;    // BIPS = Basis Points (1 = 0.01%, 100 = 1.00%, 10000 = 100.00%)
    uint256 constant USD = 10 ** 6;     // USDC / USDT precision
    uint256 constant BTC = 10 ** 8;     // wBTC precision
    uint256 constant WAD = 10 ** 18;
    uint256 constant RAY = 10 ** 27;

    uint256 constant MAX_UINT = 2**256 - 1;



    // ---------------
    //    Utilities
    // ---------------

    struct Token {
        address addr; // ERC20 Mainnet address
        uint256 slot; // Balance storage slot
        address orcl; // Chainlink oracle address
    }
 
    mapping (bytes32 => Token) tokens;

    struct TestObj {
        uint256 pre;
        uint256 post;
    }

    event Debug(string, uint256);
    event Debug(string, address);
    event Debug(string, bool);

    constructor() { hevm = Hevm(address(bytes20(uint160(uint256(keccak256("hevm cheat code")))))); }

    /// @notice Creates protocol actors.
    function createActors() public {

        // 1 Admin.
        god = new Admin();
        
        // 1 Blackhat.
        ass = new Blackhat();

        // 1 Minter.
        tom = new Minter();
    }

    /// @notice Creates mintable tokens via mint().
    function setUpTokens() public {

        tokens["USDC"].addr = USDC;
        tokens["USDC"].slot = 9;

        tokens["DAI"].addr = DAI;
        tokens["DAI"].slot = 2;

        tokens["FRAX"].addr = FRAX;
        tokens["FRAX"].slot = 0;

        tokens["USDT"].addr = USDT;
        tokens["USDT"].slot = 2;

        tokens["WETH"].addr = WETH;
        tokens["WETH"].slot = 3;

        tokens["WBTC"].addr = WBTC;
        tokens["WBTC"].slot = 0;
    }


    /// @notice Deploys the core protocol to enable minting.
    function deployCore() public {

        // Step #0 --- Run initial setup functions for simulations.
        createActors();
        setUpTokens();

    }

    // Manipulate mainnet ERC20 balance.
    function mint(bytes32 symbol, address account, uint256 amount) public {
        address addr = tokens[symbol].addr;
        uint256 slot  = tokens[symbol].slot;
        uint256 bal = IERC20(addr).balanceOf(account);

        hevm.store(
            addr,
            keccak256(abi.encode(account, slot)), // Mint tokens
            bytes32(bal + amount)
        );

        assertEq(IERC20(addr).balanceOf(account), bal + amount); // Assert new balance
    }

    // Verify equality within accuracy decimals.
    function withinPrecision(uint256 val0, uint256 val1, uint256 accuracy) public {
        uint256 diff  = val0 > val1 ? val0 - val1 : val1 - val0;
        if (diff == 0) return;

        uint256 denominator = val0 == 0 ? val1 : val0;
        bool check = ((diff * RAY) / denominator) < (RAY / 10 ** accuracy);

        if (!check){
            emit log_named_uint("Error: approx a == b not satisfied, accuracy digits ", accuracy);
            emit log_named_uint("  Expected", val0);
            emit log_named_uint("    Actual", val1);
            fail();
        }
    }

    // Verify equality within difference.
    function withinDiff(uint256 val0, uint256 val1, uint256 expectedDiff) public {
        uint256 actualDiff = val0 > val1 ? val0 - val1 : val1 - val0;
        bool check = actualDiff <= expectedDiff;

        if (!check) {
            emit log_named_uint("Error: approx a == b not satisfied, accuracy difference ", expectedDiff);
            emit log_named_uint("  Expected", val0);
            emit log_named_uint("    Actual", val1);
            fail();
        }
    }

    // Verify value falls within range.
    function constrictToRange(uint256 val, uint256 min, uint256 max) public pure returns (uint256) {
        return constrictToRange(val, min, max, false);
    }

    // Verify value falls within range and are non-zero.
    function constrictToRange(uint256 val, uint256 min, uint256 max, bool nonZero) public pure returns (uint256) {
        if      (val == 0 && !nonZero) return 0;
        else if (max == min)           return max;
        else                           return val % (max - min) + min;
    }
    
}
