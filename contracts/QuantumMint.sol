? Function 1: Mint a new token
    function mintToken(string memory _tokenURI) public {
        require(bytes(_tokenURI).length > 0, "Token URI required");

        tokenCount++;
        totalSupply++;

        tokens[tokenCount] = Token(tokenCount, msg.sender, _tokenURI);
        ownerTokens[msg.sender].push(tokenCount);

        emit TokenMinted(tokenCount, msg.sender, _tokenURI);
    }

    ? Function 3: View tokens of an owner
    function getOwnerTokens(address _owner) public view returns (uint256[] memory) {
        return ownerTokens[_owner];
    }

    update
// 
// 
update
// 
