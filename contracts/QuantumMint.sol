// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title QuantumMint
 * @dev A decentralized token minting contract allowing users to mint tokens and admin to manage supply.
 */
contract Project {
    address public admin;
    uint256 public totalSupply;
    uint256 public tokenCount;

    struct Token {
        uint256 id;
        address owner;
        string tokenURI;
    }

    mapping(uint256 => Token) public tokens;
    mapping(address => uint256[]) public ownerTokens;

    event TokenMinted(uint256 indexed id, address indexed owner, string tokenURI);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // ✅ Function 1: Mint a new token
    function mintToken(string memory _tokenURI) public {
        require(bytes(_tokenURI).length > 0, "Token URI required");

        tokenCount++;
        totalSupply++;

        tokens[tokenCount] = Token(tokenCount, msg.sender, _tokenURI);
        ownerTokens[msg.sender].push(tokenCount);

        emit TokenMinted(tokenCount, msg.sender, _tokenURI);
    }

    // ✅ Function 2: Admin can reduce total supply (burn tokens)
    function burnToken(uint256 _id) public onlyAdmin {
        Token storage t = tokens[_id];
        require(t.owner != address(0), "Token does not exist");

        totalSupply--;
        delete tokens[_id];
    }

    // ✅ Function 3: View tokens of an owner
    function getOwnerTokens(address _owner) public view returns (uint256[] memory) {
        return ownerTokens[_owner];
    }

    // ✅ Function 4: Get token details
    function getToken(uint256 _id) public view returns (Token memory) {
        require(_id > 0 && _id <= tokenCount, "Invalid token ID");
        return tokens[_id];
    }
}
