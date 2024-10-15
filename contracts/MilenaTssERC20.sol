// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MilenaTssERC20
 * @dev ERC20 Token with purchase function and transfer fee
 */
contract MilenaTssERC20 is ERC20, ERC20Permit, Ownable {
    uint256 public transferFee = 1; // 1% fee
    uint256 public tokenPrice = 1; // 1 wei

    /**
     * @dev Initializes the contract by setting the token name, symbol, owner, and minting initial supply.
     * @param initialOwner Address of the initial owner of the contract.
     */
    constructor(address initialOwner) 
        ERC20("MilenaTssERC20", "MTERC20")
        Ownable(initialOwner)
        ERC20Permit("MilenaTssERC20") {
        _mint(initialOwner, 10000 * 10 ** decimals());
    }


    /**
     * @dev Allows users to purchase tokens by sending ETH.
     * The number of tokens purchased is calculated based on the token price in wei.
     * @notice The function mints new tokens to the buyer based on the ETH sent.
     * @notice 1 wei = 1 token.
     * @notice Users must send ETH greater than 0.
     *
     * Requirements:
     * - `msg.value` must be greater than 0.
     *
     * Emits no events.
     */
    function purchase() external payable {
        require(msg.value > 0, "Send ETH to purchase tokens");
        uint256 tokensToBuy = msg.value / tokenPrice; // 1 wei = 1 token
        _mint(msg.sender, tokensToBuy);
    }

    /**
     * @dev Overrides the default ERC20 `transfer` function to include a 1% transfer fee.
     * Transfers the fee to the owner and the remaining amount to the recipient.
     * 
     * @param to The recipient's address.
     * @param amount The amount of tokens to transfer (before fee).
     * @return bool Returns true if the transfer succeeds.
     *
     * Requirements:
     * - `to` cannot be the zero address.
     * - Sender must have a balance of at least `amount`.
     *
     * Emits a {Transfer} event for both the recipient and the owner (for the fee).
     */
    function transfer(address to, uint256 amount) public override returns (bool) {
        uint256 fee = (amount * transferFee) / 100; // 1% fee
        uint256 amountAfterFee = amount - fee;

        _transfer(_msgSender(), to, amountAfterFee);
        _transfer(_msgSender(), owner(), fee); // Transfer fee to owner
        return true;
    }

    /**
     * @dev Overrides the default ERC20 `transferFrom` function to include a 1% transfer fee.
     * Transfers the fee to the owner and the remaining amount to the recipient.
     * Deducts the approved allowance from the sender.
     * 
     * @param from The address from which tokens will be deducted.
     * @param to The recipient's address.
     * @param amount The amount of tokens to transfer (before fee).
     * @return bool Returns true if the transfer succeeds.
     *
     * Requirements:
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for `from`'s tokens of at least `amount`.
     *
     * Emits a {Transfer} event for both the recipient and the owner (for the fee).
     */
    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        uint256 fee = (amount * transferFee) / 100; // 1% fee
        uint256 amountAfterFee = amount - fee;

        _transfer(from, owner(), fee); // Transfer fee to owner
        _transfer(from, to, amountAfterFee);
        _spendAllowance(from, _msgSender(), amountAfterFee);
        return true;
    }
}



/**
* @dev See {IERC20-transfer}.
*
* Requirements:
*
* - `to` cannot be the zero address.
* - the caller must have a balance of at least `value`.
*/
// function transfer(address to, uint256 value) public virtual returns (bool) {
//     address owner = _msgSender();
//     _transfer(owner, to, value);
//     return true;
// }

/**
* @dev See {IERC20-transferFrom}.
*
* Emits an {Approval} event indicating the updated allowance. This is not
* required by the EIP. See the note at the beginning of {ERC20}.
*
* NOTE: Does not update the allowance if the current allowance
* is the maximum `uint256`.
*
* Requirements:
*
* - `from` and `to` cannot be the zero address.
* - `from` must have a balance of at least `value`.
* - the caller must have allowance for ``from``'s tokens of at least
* `value`.
*/
// function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
//     address spender = _msgSender();
//     _spendAllowance(from, spender, value);
//     _transfer(from, to, value);
//     return true;
// }

/**
* @dev Moves a `value` amount of tokens from `from` to `to`.
*
* This internal function is equivalent to {transfer}, and can be used to
* e.g. implement automatic token fees, slashing mechanisms, etc.
*
* Emits a {Transfer} event.
*
* NOTE: This function is not virtual, {_update} should be overridden instead.
*/
// function _transfer(address from, address to, uint256 value) internal {
//     if (from == address(0)) {
//         revert ERC20InvalidSender(address(0));
//     }
//     if (to == address(0)) {
//         revert ERC20InvalidReceiver(address(0));
//     }
//     _update(from, to, value);
// }


/**
* @dev Creates a `value` amount of tokens and assigns them to `account`, by transferring it from address(0).
* Relies on the `_update` mechanism
*
* Emits a {Transfer} event with `from` set to the zero address.
*
* NOTE: This function is not virtual, {_update} should be overridden instead.
*/
// function _mint(address account, uint256 value) internal {
//     if (account == address(0)) {
//         revert ERC20InvalidReceiver(address(0));
//     }
//     _update(address(0), account, value);
// }

/**
* @dev Transfers a `value` amount of tokens from `from` to `to`, or alternatively mints (or burns) if `from`
* (or `to`) is the zero address. All customizations to transfers, mints, and burns should be done by overriding
* this function.
*
* Emits a {Transfer} event.
*/
// function _update(address from, address to, uint256 value) internal virtual {
//         if (from == address(0)) {
//             // Overflow check required: The rest of the code assumes that totalSupply never overflows
//             _totalSupply += value;
//         } else {
//             uint256 fromBalance = _balances[from];
//             if (fromBalance < value) {
//                 revert ERC20InsufficientBalance(from, fromBalance, value);
//             }
//             unchecked {
//                 // Overflow not possible: value <= fromBalance <= totalSupply.
//                 _balances[from] = fromBalance - value;
//             }
//         }

//         if (to == address(0)) {
//             unchecked {
//                 // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
//                 _totalSupply -= value;
//             }
//         } else {
//             unchecked {
//                 // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
//                 _balances[to] += value;
//             }
//         }

//         emit Transfer(from, to, value);
//     }
