// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EnergyToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("EnergyToken", "ETK") {
        _mint(msg.sender, initialSupply * 10 ** decimals()); // Mint initial supply of tokens
    }

    // Mint new tokens if necessary (for future energy generation)
    function mintTokens(address to, uint256 amount) public {
        _mint(to, amount);
    }

    // Burn tokens (for example, if energy is consumed)
    function burnTokens(address from, uint256 amount) public {
        _burn(from, amount);
    }
}
