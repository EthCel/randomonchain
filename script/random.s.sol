// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/nftcast.sol";

contract randomcasting is randomCasting(7334) {
    constructor() {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
    }
}

contract castScript is Script {
    function setUp() public {}

    function run() public {
        uint private_key = vm.envUint("PRIVATE_KEY");
        address account = vm.addr(private_key);
        console.log(account);

        vm.startBroadcast(private_key);
        randomCasting randomcasting = new randomCasting(7334);
        vm.stopBroadcast();
    }
}
