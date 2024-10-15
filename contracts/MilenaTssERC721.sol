// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


 /**
 * @title MilenaTssERC721
 * @dev ERC721 token with minting functions and metadata (URI) support.
 * Tokens can only be minted by the contract owner.
 */
contract MilenaTssERC721 is ERC721, ERC721URIStorage, Ownable {
    /**
     * @notice Constructor for the contract, sets the token name, symbol, and initial owner.
     * @dev Initializes the token name and symbol. The owner of the contract is set through the parameter.
     * @param initialOwner The address of the initial owner of the contract.
     */
    constructor(address initialOwner) 
        ERC721("MilenaTssERC721", "MTERC721")
        Ownable(initialOwner) {}

    /**
     * @notice Function to safely mint a new token without a URI.
     * @dev Mints a token with a unique `tokenId` and transfers it to the specified address. Only the owner of the contract can call this function.
     * @param to The address that will own the newly minted token.
     * @param tokenId The unique identifier for the token to be minted.
     */
    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

    /**
     * @notice Function to safely mint a new token with a specified URI.
     * @dev Mints a token with a unique `tokenId`, transfers it to the specified address, and assigns a metadata URI to it. Only the owner of the contract can call this function.
     * @param to The address that will own the newly minted token.
     * @param tokenId The unique identifier for the token to be minted.
     * @param uri The URI of the metadata associated with the token (e.g., a link to a JSON file).
     */
    function safeMint(address to, uint256 tokenId, string memory uri) public onlyOwner {
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    /**
     * @notice Retrieves the metadata URI for a given token ID.
     * @dev Overrides the function from `ERC721URIStorage` to return the URI associated with the token.
     * @param tokenId The unique identifier for the token.
     * @return A string containing the metadata URI for the token.
     */
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    /**
     * @notice Checks support for interfaces.
     * @dev Overrides the `supportsInterface` function from `ERC721` and `ERC721URIStorage`.
     * @param interfaceId The 4-byte identifier of the interface to check for support.
     * @return Returns true if the interface is supported, otherwise false.
     */
    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
