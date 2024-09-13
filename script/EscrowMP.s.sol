// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {EscrowMP, Groth16Verifier} from "../src/EscrowMP.sol";
import {MockERC20} from "../src/MockERC20.sol";

contract EscrowMPScript is Script {
    EscrowMP public escrow;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        MockERC20 token = new MockERC20("USDT", "USDT");
        token.mint(msg.sender, 100e6);
        Groth16Verifier verifier = new Groth16Verifier();

        escrow = new EscrowMP(address(verifier));

        vm.stopBroadcast();
    }
}
