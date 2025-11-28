// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title QuantumMint
 * @notice Dynamic NFT Minting with Random Traits + Reveal System
 */

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract QuantumMint is ERC721Enumerable, Ownable, ReentrancyGuard {
    using Strings for uint256;

    uint256 public maxSupply = 10000;
    uint256 public mintPrice = 0.01 ether;

    string public baseURI;
    string public hiddenURI;

    bool public revealed = false;

    constructor(string memory _hiddenURI) ERC721("QuantumMint", "QNTM") {
        hiddenURI = _hiddenURI;
    }

    // -------- Public Mint --------
    function mint(uint256 quantity) external payable nonReentrant {
        require(quantity > 0, "Quantity must be > 0");
        require(totalSupply() + quantity <= maxSupply, "Sold out");
        require(msg.value >= mintPrice * quantity, "Insufficient ETH");

        for (uint256 i = 0; i < quantity; i++) {
            uint256 newId = totalSupply() + 1;
            _safeMint(msg.sender, newId);
        }
    }

    // -------- Metadata Reveal Logic --------
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "NFT does not exist");

        if (!revealed) return hiddenURI;

        return string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json"));
    }

    function reveal(string memory _baseURI) external onlyOwner {
        require(!revealed, "Already revealed");
        baseURI = _baseURI;
        revealed = true;
    }

    // -------- Owner Controls --------
    function setMintPrice(uint256 newPrice) external onlyOwner {
        mintPrice = newPrice;
    }

    function setMaxSupply(uint256 newMax) external onlyOwner {
        require(newMax >= totalSupply(), "Cannot reduce below minted tokens");
        maxSupply = newMax;
    }

    function setHiddenURI(string memory newHiddenURI) external onlyOwner {
        hiddenURI = newHiddenURI;
    }

    // -------- Withdraw --------
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
