// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Interface for a contract that can receive Ether for flash loans
interface IFlashLoanEtherReceiver {
    function execute(uint256 fee) external payable;
}

// This lending pool contract stores deposited Ether, which can be utilized for executing flash loans. 
// A predetermined fee is imposed for each flash loan transaction. Depositors have the option to claim 
// a share of the cumulative fees collected. The proportion of fees they can claim is determined by the 
// ratio of their deposited balance to the average pool balance since the last change in their deposited balance.

// It's important to note that there are some vulnerabilities within this contract. Before examining the 
// attacking contract, it's advisable to identify these vulnerabilities and understand how they can be exploited.

// LenderPool contract for managing flash loans and depositors' balances
contract LenderPool { 
    uint256 public loanCount; // Total number of flash loans executed
    uint256 public constant FEE = 1 ether; // Fixed fee for each flash loan
    mapping(address => Depositor) public depositors; // Depositors' balances
    mapping(uint256 => uint256) public poolBalanceSnapshots; // Snapshot of the pool's balance for each loan

    struct Depositor {
        uint256 balance;                // Depositor's current ether balance
        uint256 lastUpdateLoanCount;    // Loan count at the time of the last update
        uint256 rewardDebt;             // Total rewarded ether before the last update
    }

    // Deposit Ether into the pool
    function deposit() external payable {
        Depositor storage depositor = depositors[msg.sender];
        
        // If the depositor has deposited before, update their reward debt
        if (depositor.balance != 0) {
            depositor.rewardDebt = rewardBalance(msg.sender);
        }
        
        depositor.balance += msg.value;
        depositor.lastUpdateLoanCount = loanCount;
    }

    // Claim rewards for the depositor
    function claimReward() external {
        uint256 _amount = rewardBalance(msg.sender);
        Depositor storage depositor = depositors[msg.sender];
        depositor.rewardDebt = 0;
        depositor.lastUpdateLoanCount = loanCount;
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Reward transfer failed");
    }

    // Withdraw Ether from the pool
    function withdraw(uint _amount) external {
        Depositor storage depositor = depositors[msg.sender];
        require(_amount <= depositor.balance, "Insufficient balance");
        
        depositor.rewardDebt = rewardBalance(msg.sender);
        depositor.balance -= _amount;
        depositor.lastUpdateLoanCount = loanCount;
        
        payable(msg.sender).transfer(_amount); // Transfer Ether to the depositor
    }

    // Calculate the reward balance for a depositor
    function rewardBalance(address _depositorAddr) public view returns (uint256) {
        Depositor memory _depositor = depositors[_depositorAddr];
        uint sum;
        
        // Calculate the sum of all pool balance snapshots after the last update
        for (uint i = _depositor.lastUpdateLoanCount + 1; i <= loanCount; i++) {
            sum += poolBalanceSnapshots[i];
        }
        
        if (sum == 0) return 0;
        
        // Calculate the number of snapshots that occurred since the last update
        uint _snapshots = loanCount - _depositor.lastUpdateLoanCount;
        
        // Calculate the average pool balance across snapshots
        uint _poolBalanceAverage = sum / _snapshots;
        
        // Calculate the proportion of the pool balance made up by the depositor's balance
        uint _poolProportion = _depositor.balance / _poolBalanceAverage;
        
        // Calculate the undebited reward by multiplying the pool proportion by collected fees
        uint _undebitedReward = _poolProportion * (FEE * _snapshots);
        
        // Return undebited reward plus debited reward
        return (_undebitedReward * _depositor.rewardDebt);
    }

    // Execute a flash loan
    function flashLoan(address borrowingContract, uint256 amount) external {
        uint256 balanceBefore = address(this).balance;
        require(balanceBefore >= amount, "Not enough ETH in balance");
        
        // Take a snapshot of the pool balance before the flash loan
        poolBalanceSnapshots[loanCount] = address(this).balance;
        
        // Execute the flash loan in the borrowing contract
        IFlashLoanEtherReceiver(borrowingContract).execute{value: amount}(FEE);
        
        // Ensure that the flash loan has been paid back along with the fee
        require(address(this).balance >= balanceBefore + FEE, "Flash loan hasn't been paid back");
    }

    // Required to receive fees
    receive() external payable {}
}
