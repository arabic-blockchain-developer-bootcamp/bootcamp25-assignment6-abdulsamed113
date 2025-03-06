// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Assignment6 {
    // Custom errors
    error DepositAmountMustBeGreaterThanZero();
    error InsufficientBalance();

    // 1. Declare an event called `FundsDeposited` with parameters: `sender` and `amount`
    event FundsDeposited(address indexed sender, uint256 amount);

    // 2. Declare an event called `FundsWithdrawn` with parameters: `receiver` and `amount`
    event FundsWithdrawn(address indexed receiver, uint256 amount);

    // 3. Create a public mapping called `balances` to track user balances
    mapping(address => uint256) public balances;

    // Modifier to check if sender has enough balance
    modifier hasEnoughBalance(uint256 amount) {
        if (balances[msg.sender] < amount) revert InsufficientBalance();
        _;
    }

    // Function to deposit Ether
    function deposit() external payable {
        if (msg.value == 0) revert DepositAmountMustBeGreaterThanZero();

        // Increment user balance in balances mapping
        balances[msg.sender] += msg.value;

        // Emit event
        emit FundsDeposited(msg.sender, msg.value);
    }

    // Function to withdraw Ether
    function withdraw(uint256 amount) external hasEnoughBalance(amount) {
        // Deduct user balance before sending to prevent reentrancy
        balances[msg.sender] -= amount;

        // Transfer Ether to the caller
        payable(msg.sender).transfer(amount);

        // Emit event
        emit FundsWithdrawn(msg.sender, amount);
    }

    // Function to check the contract balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
