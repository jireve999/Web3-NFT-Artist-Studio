// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface DividendPayingTokenInterface {
    function dividendOf(address _owner) external view returns(uint256);

    function distributeDividends() external payable;

    function withdrawDividend() external;

    event DividendsDistributed(
        address indexed from,
        uint256 weiAmount
    );

    event DividendWithdrawn (
        address indexed to,
        uint256 weiAmount
    );
}