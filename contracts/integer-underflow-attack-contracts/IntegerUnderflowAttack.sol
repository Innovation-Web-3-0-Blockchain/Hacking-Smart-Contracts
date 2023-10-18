// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./LenderPoolOne.sol";

// Contract to simulate integer underflow
contract IntegerUnderflowAttack is LenderPoolOne {
    // Override the withdraw function to simulate integer underflow
    function withdraw(uint _amount) external override {
        Depositor storage depositor = depositors[msg.sender];
        
        // Simulate an integer underflow by omitting bounds checks
        // Note: This is for educational purposes only and should not be used in real contracts.
        // In practice, you should always perform proper bounds checks.
        
        depositor.balance -= _amount;
        depositor.lastUpdateLoanCount = loanCount;
        
        payable(msg.sender).transfer(_amount); // Transfer Ether to the depositor
    }
}
