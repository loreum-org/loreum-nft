// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.19;

import {Test} from "lib/forge-std/src/test.sol";
import {Explorers} from "../src/Explorers.sol";
import {IERC721} from "lib/openzeppelin-contracts/contracts/interfaces/IERC721.sol";
import {IERC721Metadata} from "lib/openzeppelin-contracts/contracts/interfaces/IERC721Metadata.sol";
import {IERC721Enumerable} from "lib/openzeppelin-contracts/contracts/interfaces/IERC721Enumerable.sol";
import {Actors} from "script/Actors.sol";
import {Constants} from "script/Constants.sol";
import {Strings} from "lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract ExplorersTest is Test {
    Explorers public explorers;
    address user = address(2);

    function setUp() public {
        vm.startPrank(Actors.DEPLOYER);
        explorers = new Explorers(
            Actors.DEPLOYER,
            Constants.MAX_SUPPLY,
            Constants.MINT_COST,
            Constants.BASE_URI,
            Constants.NAME,
            Constants.SYMBOL
        );
        explorers.transferOwnership(Actors.OWNER);
        vm.stopPrank();
    }

    function test_SupportsInterface() public view {
        assertTrue(explorers.supportsInterface(type(IERC721).interfaceId));
        assertTrue(explorers.supportsInterface(type(IERC721Metadata).interfaceId));
        assertTrue(explorers.supportsInterface(type(IERC721Enumerable).interfaceId));
    }

    function test_TokenURI() public {
        vm.startPrank(Actors.OWNER);
        deal(Actors.OWNER, 0.05 ether);
        explorers.mint{value: 0.05 ether}();
        vm.stopPrank();
        string memory expectedURI = string(abi.encodePacked(Constants.BASE_URI, Strings.toString(1)));
        assertEq(explorers.tokenURI(1), expectedURI);
    }

    function test_mint() public {
        vm.startPrank(user);
        vm.deal(user, 0.05 ether);
        explorers.mint{value: 0.05 ether}();
        assertEq(explorers.balanceOf(user), 1);
        assertEq(explorers.totalSupply(), 1);
        vm.stopPrank();
    }

    function testFallback() public {
        vm.startPrank(user);
        vm.deal(user, 1 ether);
        (bool success,) = address(explorers).call{value: 0.1 ether}("");
        assertTrue(success);
        vm.stopPrank();
    }

    function testReceive() public {
        vm.startPrank(user);
        vm.deal(user, 1 ether);
        (bool success,) = address(explorers).call{value: 0.1 ether}("");
        assertTrue(success);
        vm.stopPrank();
    }

    function test_migrate_success() public {
        address[] memory owners = new address[](3);
        owners[0] = address(3);
        owners[1] = address(4);
        owners[2] = address(5);

        uint256[] memory tokenIds = new uint256[](3);
        tokenIds[0] = 1;
        tokenIds[1] = 2;
        tokenIds[2] = 3;

        vm.startPrank(Actors.OWNER);
        explorers.migrate(owners, tokenIds);
        vm.stopPrank();

        assertEq(explorers.balanceOf(address(3)), 1);
        assertEq(explorers.balanceOf(address(4)), 1);
        assertEq(explorers.balanceOf(address(5)), 1);
        assertEq(explorers.totalSupply(), 3);
    }

    function test_mint_insufficientFunds() public {
        vm.startPrank(user);
        vm.deal(user, 0.01 ether);
        vm.expectRevert(Explorers.MintCost.selector);
        explorers.mint{value: 0.01 ether}();
        vm.stopPrank();
    }

    function skip_test_mint_exceedMaxSupply() public {
        vm.startPrank(Actors.OWNER);
        for (uint256 i = 0; i < Constants.MAX_SUPPLY; i++) {
            explorers.mint{value: Constants.MINT_COST}();
        }
        vm.expectRevert(Explorers.MaxSupply.selector);
        explorers.mint{value: Constants.MINT_COST}();
        vm.stopPrank();
    }

    function test_mint_multiple() public {
        vm.startPrank(user);
        vm.deal(user, 0.15 ether);
        for (uint256 i = 0; i < 3; i++) {
            explorers.mint{value: 0.05 ether}();
        }
        assertEq(explorers.balanceOf(user), 3);
        assertEq(explorers.totalSupply(), 3);
        vm.stopPrank();
    }
}
