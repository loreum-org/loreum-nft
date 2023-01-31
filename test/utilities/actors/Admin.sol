// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.16;
pragma experimental ABIEncoderV2;

contract Admin {

    /// @notice Handles arbitrary call() executions to address(this).
    fallback() external payable { }

    /// @notice Handles arbitrary direct ETH transfers.
    receive() external payable { }

    /*********************/
    /*** TRY FUNCTIONS ***/
    /*********************/

    function try_updateMintCost(address NFT, uint256 amount) external returns (bool ok) {
        string memory sig = "updateMintCost(uint256)";
        (ok,) = address(NFT).call(abi.encodeWithSignature(sig, amount));
    }

}