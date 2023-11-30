// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "../lib/chainlink-brownie-contracts/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract randomCasting is ERC721, VRFConsumerBaseV2 {
    uint256 public constant totalySupply = 10;
    uint256[10] public ids;
    uint256 public mintCount;

    error mintClosed();

    VRFCoordinatorV2Interface COORDINATOR;

    mapping(uint256 => address) public idToSender;
    uint64 subId;
    uint256 public requestId;
    address constant vrfCoordinator =
        0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625;
    bytes32 constant keyHash =
        0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;
    uint16 constant requestConfirmations = 3;
    uint32 constant callbackGasLimit = 200_000;
    uint32 constant numWords = 1;

    constructor(
        uint64 s_subId
    ) ERC721("gitcoin", "gcoin") VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        subId = s_subId;
    }

    function getTokenId(uint256 random) private returns (uint256 tokenId) {
        uint256 availableTokens = totalySupply - mintCount++;
        if (availableTokens < 0) {
            revert mintClosed();
        }
        uint256 randomIndex = random % availableTokens;

        // if index is taken (non-zero) use ids[randomIndex]
        // if it's not take just use randomIndex
        tokenId = ids[randomIndex] != 0 ? ids[randomIndex] : randomIndex;
    }

    function requestRandomWords() external {
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            subId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );

        idToSender[requestId] = msg.sender;
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory s_randomWords
    ) internal override {
        address minter = idToSender[requestId];
        uint256 tokenId = getTokenId(s_randomWords[0]);
        _mint(minter, tokenId);
    }
}
