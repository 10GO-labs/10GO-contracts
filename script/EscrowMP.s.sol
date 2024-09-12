// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {EscrowMP} from "../src/EscrowMP.sol";
import {MockERC20} from "../src/MockERC20.sol";

contract EscrowMPScript is Script {
    EscrowMP public escrow;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        MockERC20 token = new MockERC20("USDT", "USDT");
        token.mint(msg.sender, 100e6);

        escrow = new EscrowMP(address(0));  // TODO pass a verifier address

        vm.stopBroadcast();
    }
}
