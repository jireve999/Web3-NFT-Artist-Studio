// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./dividend/DividendPayingTokenInterface.sol";
import "./dividend/DividendPayingTokenOptionalInterface.sol";

contract ArtistCoin is
    ERC20,
    Ownable,
    ReentrancyGuard,
    DividendPayingTokenInterface,
    DividendPayingTokenOptionalInterface
{
    uint256 public constant MAX_SUPPLY = 100 ether;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    uint256 internal constant magnitude = 2**128;
    uint256 internal magnifiedDividendPerShare;
    uint256 public ownerWithdrawable;

    bool public locked;

    mapping(address => int256) internal magnifiedDividendCorrections;
    mapping(address => int256) internal withdrawnDividends;
    modifier mintable(uint256 amount) {
        require(
            amount + totalSupply() <= MAX_SUPPLY,
            "amount surpasses max supply"
        );
        _;
    }
    modifier isUnlocked() {
        require(!locked, "contract is currently locked");
        _;
    }

    receive() external payable {
        distributeDividends();
    }

    function mint(address to_) public payable mintable(msg.value) {
        ownerWithdrawable += msg.value;
        _mint(to_, msg.value);
    }
    function collect() public onlyOwner nonReentrant {
        require(ownerWithdrawable > 0);
        uint _with = ownerWithdrawable;
        ownerWithdrawable = 0;
        payable(msg.sender).transfer(_with);
    }
    function toogleLock() external onlyOwner {
        locked = !locked;
    }

    function distributeDividends() public payable {
        require(totalSupply() > 0);

        if (_.value > 0) {
            magnifiedDividendPerShare +=
                (msg.value * magnitude) /
                totalSupply();
            emit DividendsDistributed(msg.sender, msg.value);
        }
    }

    function withdrawDividend() public nonReentrant isUnlocked {
        uint256 _withdrawableDividend = withdrawableDividendOf(msg.sender);
        if (_withdrawableDividend > 0) {
            withdrawnDividends[msg.sender] += _withdrawableDividend;
            emit DividendWithdrawn(msg.sender, _withdrawableDividend);
            (payable(msg.sender)).transfer(_withdrawableDividend);
        }
    }

    function dividendOf(address_owner) public view returns (uint256) {
        return withdrawableDividendOf(_owner);
    }

    function withdrawableDividendOf(address _owner) public view returns (uint256) {
        return accumulativeDividendOf(_owner) - (withdrawDividends[_owner]);
    }

    function withdrawnDividendOf(address _owner) public view returns (uint256) {
        return withdrawnDividends[_owner];
    }

    function accumulativeDividendOf(address _owner) public view  returns (uint256) {
        int256 x = int256(magnifiedDividendPerShare * balanceOf(_owner));

        x+= magnifiedDividendCorrections[_owner];
        return uint256(x) / magnitude;
    }

    function _transfer (
        address from,
        address to,
        uint256 value
    ) internal override {
        super._transfer(from, to, value);

        int256 _magCorrection = int256(magnifiedDividendPerShare * (value));
        magnifiedDividendCorrections[from] += _magCorrection;
        magnifiedDividendCorrections[to] -= _magCorrection;
    }

    function _mint(address account, uint256 value) internal  override {
        super._mint(account, value);

        magnifiedDividendCorrections[account] -= int256(
            magnifiedDividendPerShare * value
        );
    }

    function _burn(address account, uint256 value) internal override {
        super._burn(account, value);

        magnifiedDividendCorrections[account] += int256(
            magnifiedDividendPerShare * value
        );
    }

}