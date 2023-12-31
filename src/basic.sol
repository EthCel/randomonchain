// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "../lib/chainlink-brownie-contracts/contracts/src/v0.8/VRFConsumerBaseV2.sol";

// randomness on the sepolia testnet
contract RandomNumberConsumer is
    VRFConsumerBaseV2(0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625)
{
    VRFCoordinatorV2Interface COORDINATOR;

    uint64 subId;

    uint256 public requestId;

    uint256[] randomWords;

    // coordinator for sepolia
    address constant vrfCoordinator =
        0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625;

    // 150 gwei gas lane
    bytes32 constant keyHash =
        0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;

    uint16 constant requestConfirmations = 3;

    uint32 constant callbackGasLimit = 200_000;

    uint32 constant numWords = 3;

    constructor(uint64 s_subId) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        subId = s_subId;
    }

    // user calls this function to request
    // random numbers
    function requestRandomWords() external {
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            subId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    // fallback function
    //
    // VRF calls this to
    // send the number
    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory s_randomWords
    ) internal override {
        randomWords = s_randomWords;
        // use the random numbers
        //
        // lotteries, nft casting etc.
    }
}
