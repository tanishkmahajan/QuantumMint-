// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title QuantumMint
 * @notice A decentralized NFT minting and verification protocol enabling creators
 *         to mint quantum-secure NFTs with metadata, ownership tracking, and admin verification.
 */
contract Project {
    address public admin;
    uint256 public tokenCount;

    struct NFT {
        uint256 id;
        address creator;
        string metadataURI;
        uint256 timestamp;
        bool verified;
    }

    mapping(uint256 => NFT) public nfts;
    mapping(address => uint256[]) public creatorTokens;

    event NFTMinted(uint256 indexed id, address indexed creator, string metadataURI);
    event NFTVerified(uint256 indexed id, address indexed verifier);
    event AdminChanged(address indexed oldAdmin, address indexed newAdmin);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @notice Mint a new QuantumMint NFT.
     * @param _metadataURI The URI containing NFT metadata (IPFS, Arweave, etc.)
     */
    function mintNFT(string memory _metadataURI) external {
        require(bytes(_metadataURI).length > 0, "Metadata URI required");

        tokenCount++;
        nfts[tokenCount] = NFT(
            tokenCount,
            msg.sender,
            _metadataURI,
            block.timestamp,
            false
        );

        creatorTokens[msg.sender].push(tokenCount);

        emit NFTMinted(tokenCount, msg.sender, _metadataURI);
    }

    /**
     * @notice Verify an NFT (admin only)
     * @param _id The NFT ID to verify
     */
    function verifyNFT(uint256 _id) external onlyAdmin {
        require(_id > 0 && _id <= tokenCount, "Invalid NFT ID");
        require(!nfts[_id].verified, "Already verified");

        nfts[_id].verified = true;

        emit NFTVerified(_id, msg.sender);
    }

    /**
     * @notice Change the admin of the protocol
     * @param _newAdmin Address of the new admin
     */
    function changeAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Invalid admin address");

        address oldAdmin = admin;
        admin = _newAdmin;

        emit AdminChanged(oldAdmin, _newAdmin);
    }

    /**
     * @notice Fetch full NFT details by ID
     * @param _id NFT ID
     */
    function getNFT(uint256 _id) external view returns (NFT memory) {
        require(_id > 0 && _id <= tokenCount, "Invalid NFT ID");
        return nfts[_id];
    }

    /**
     * @notice Fetch all tokens minted by a creator
     * @param _creator Address of creator
     */
    function getCreatorTokens(address _creator) external view returns (uint256[] memory) {
        return creatorTokens[_creator];
    }
}
// 
End
// 
