// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {EscrowMP} from "../src/EscrowMP.sol";

contract EscrowMPTest is Test {
    EscrowMP public escrow;

    function setUp() public {
        escrow = new EscrowMP(address(0));
    }
}
