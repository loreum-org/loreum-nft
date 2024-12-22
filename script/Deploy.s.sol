// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "lib/forge-std/src/Script.sol";
import {Explorers} from "../src/Explorers.sol";
import {Actors} from "./Actors.sol";
import {Constants} from "./Constants.sol";

contract DeployExplorers is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the Explorers contract
        Explorers explorers = new Explorers(
            Actors.OWNER,
            Constants.MAX_SUPPLY,
            Constants.MINT_COST,
            Constants.BASE_URI,
            Constants.NAME,
            Constants.SYMBOL
        );

        vm.stopBroadcast();
    }
}
