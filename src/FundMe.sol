// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error FundMe__NotOwner();

contract FundMe {
    // Type Declarations
    using PriceConverter for uint256;
    // 最小金额

    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    mapping(address => uint256) private s_addressToAmountFunded;
    address[] private s_funders;
    address private immutable i_owner;
    // 价格
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "you need to speed more ETH!");
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function withdraw() external onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            s_addressToAmountFunded[s_funders[funderIndex]] = 0;
        }
        s_funders = new address[](0);
        (bool success,) = i_owner.call{value: address(this).balance}("");
        require(success);
    }

    function getAddressToAmountFunded(address fundingAddress) public view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }
}
