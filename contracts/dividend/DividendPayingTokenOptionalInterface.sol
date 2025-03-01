// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface DividendPayingTokenOptionalInterface {
    function withdrawableDividendOf(address _owner) external view returns(uint256);

    function withdrawnDividendOf(address _owner) external view returns(uint256);

    function accumulativeDividendOf(address _owner) external view returns(uint256);
}