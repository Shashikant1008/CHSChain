// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Escrow {
    mapping(address => uint256) public balances;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function releaseFunds(address payable recipient, uint256 amount) public {
        require(msg.sender == admin, "Only admin can release funds");
        require(balances[recipient] >= amount, "Insufficient funds");
        balances[recipient] -= amount;
        recipient.transfer(amount);
    }
}
