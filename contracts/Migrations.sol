// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Migrations {
    address public owner;
    uint public last_completed_migration;

    constructor() {
        owner = msg.sender;
    }

    modifier restricted() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    function setCompleted(uint completed) public restricted {
    require(completed > last_completed_migration, "Completed should be greater than the last completed migration.");
    last_completed_migration = completed;
    }

}
