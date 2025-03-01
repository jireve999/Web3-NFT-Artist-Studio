// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ArtistNFT is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Royalty, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint96 royaltyFraction = 200;
    uint feeRate = 1 gwei;
    address feeCollector;
    function setFeeRoyaltyFraction(uint96 rf)external onlyOwner {
        royaltyFraction = rf;
    }
    function setFeeRate(uint fr)external onlyOwner {
        feeRate = fr;
    }
    function setFeeCollector(address fc)external onlyOwner {
        feeCollector = fc;
    }

    constructor() ERC721("ArtistNFT", "AN") {}

    function withdraw() external  {
        require(msg.sender == feeCollector,  "only fee collector can withdraw");
        (bool suc, bytes memory data) = feeCollector.call{value: address(this).balance}("");
        require(suc, "withdraw failed!");
    }

    function mint(address artist, string memory tokenURI_)
        public
        payable
        returns (uint256)
    {
        require(msg.value > feeRate, "Please provide 1g wei for your minting!");
        uint256 newItemId = _tokenIds.current();
        _mint(artist, newItemId);
        _setTokenURI(newItemId, tokenURI_);

        _tokenIds.increment();
        _setTokenRoyalty(newItemId, artist, royaltyFraction);
        return newItemId;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage, ERC721Royalty)
    {
        super._burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Royalty)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}