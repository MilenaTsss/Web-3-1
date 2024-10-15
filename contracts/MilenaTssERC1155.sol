// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol"; // Importing the Strings library

/**
 * @title MilenaTssERC1155
 * @dev ERC1155 token with minting functions and metadata (URI) support.
 * Tokens can only be minted by the contract owner.
 */
contract MilenaTssERC1155 is ERC1155, Ownable, ERC1155Supply {
    /// @notice Base URI for metadata
    string private _baseURI;

    /**
     * @notice Constructor for the contract, sets the initial URI for all token types.
     * @dev Initializes the contract by setting the initial owner and URI for metadata.
     * @param baseURI The base URI for metadata.
     * @param initialOwner The address of the initial owner of the contract.
     */
     constructor(string memory baseURI, address initialOwner) ERC1155(baseURI) Ownable(initialOwner) {
        _baseURI = baseURI;
     }

    /**
     * @notice Function to mint new tokens with metadata.
     * @dev Mints a specified amount of tokens for a given token ID.
     * Only the owner of the contract can call this function.
     * @param to The address that will own the newly minted tokens.
     * @param id The unique identifier for the token to be minted.
     * @param amount The amount of tokens to be minted.
     * @param data Additional data to send along with the minting, 
     */
    function mint(address to, uint256 id, uint256 amount, bytes memory data) public onlyOwner {
        _mint(to, id, amount, data);
    }

    /**
     * @notice Function to mint a batch of tokens.
     * @dev Mints a batch of tokens for given token IDs.
     * Only the owner of the contract can call this function.
     * @param to The address that will own the newly minted tokens.
     * @param ids An array of unique identifiers for the tokens to be minted.
     * @param amounts An array of amounts for each token to be minted.
     * @param data Additional data to send along with the minting, 
     */
    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }

    /**
     * @notice Retrieves the metadata URI for a given token ID.
     * @dev Constructs the URI for the token using the base URI and token ID.
     * @param id The unique identifier for the token.
     * @return A string containing the metadata URI for the token.
     */
    function uri(uint256 id) public view override returns (string memory) {
        return string(abi.encodePacked(_baseURI, Strings.toString(id)));
    }

    // The following functions are overrides required by Solidity.
    function _update(address from, address to, uint256[] memory ids, uint256[] memory values) internal override(ERC1155, ERC1155Supply) {
        super._update(from, to, ids, values);
    }
}
