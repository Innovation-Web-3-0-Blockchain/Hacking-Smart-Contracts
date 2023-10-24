// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FlashLoanReceiver {
    address payable public pool;

    // Constructor to initialize the contract with the lender pool's address.
    constructor(address payable poolAddress) {
        pool = poolAddress;
    }

    // Function called by the lender pool during a flash loan.
    function execute(uint256 fee) public payable {
        // Ensure that the sender is the lender pool.
        require(msg.sender == pool, "Sender must be pool");

        // Calculate the total amount to be repaid, including the fee.
        uint256 amountToBeRepaid = msg.value + fee;

        // Ensure that the contract has enough balance to repay the loan.
        require(address(this).balance >= amountToBeRepaid, "Cannot borrow that much");

        // Execute the custom action during the flash loan.
        _executeActionDuringFlashLoan();

        // Return the funds to the lender pool.
        (bool sent, ) = msg.sender.call{value: amountToBeRepaid}("");
        require(sent, "Failed to send Ether");
    }

    // Internal function where the funds received during the flash loan are used.
    function _executeActionDuringFlashLoan() internal {

        // The attacker implement his custom logic here for utilizing the borrowed funds.
        // This function should be overridden in derived contracts.

    }

    // Allow deposits of Ether into this contract.
    receive() external payable {}
}
