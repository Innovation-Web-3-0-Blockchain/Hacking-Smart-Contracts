# Contracts 

- [Lending Pool Contracts](#lending-pool-contracts)
   - [LenderPool Contract](#lenderpool-contract)
   - [LenderPoolOne Contract](#lenderpoolone-contract)
- [Attack Contracts](#attack-contracts)
   - [ReentrancyAttack Contract](#reentrancyattack-contract)
   - [IntegerUnderflowAttack Contract](#integerunderflowattack-contract)
- [Attack Testing](#attack-testing)
   - [Reentrancy Attack Test](#reentrancy-attack-test)
   - [IntegerUnderflow Attack Test](#integerunderflow-attack-test)
- [FlashLoanReceiver Contract](#flashloanreceiver-contract)

---

## Lending Pool Contracts

### LenderPool Contract 

The `LenderPool.sol` contract exposes several significant vulnerabilities that could be exploited to compromise the contract's security. These vulnerabilities and the risks they pose are outlined below:

1. **Reentrancy Vulnerability**: The `LenderPool.sol` contract does not use the reentrancy guard modifier `nonReentrant` for its external functions. This leaves it vulnerable to reentrancy attacks where malicious contracts can make recursive calls to external contracts and manipulate their state.

2. **Integer Overflow**: There is no check for integer overflow in various arithmetic operations, particularly when calculating rewards and updating balances. An attacker could potentially manipulate these values to exploit an overflow vulnerability.

3. **Unchecked External Calls**: The `execute` function in the `IFlashLoanEtherReceiver` interface is called without any checks or validations. If the receiving contract has malicious code or vulnerabilities, this contract could be exploited.

4. **Lack of Access Control**: There is no access control mechanism to restrict certain functions to authorized users only. Anyone can deposit, withdraw, or claim rewards, which could lead to misuse.

5. **Flash Loan Vulnerability**: The `flashLoan` function allows borrowing Ether without any collateral or checks. If a malicious contract repeatedly calls this function and doesn't repay the loan, it can drain the pool's funds.

---

### LenderPoolOne Contract

The `LenderPoolOne.sol` contract employs the same code framework as the `LenderPool.sol` contract, with the sole distinction being the use of different artifacts to define certain variables. This ensures that there is no interference during various attack testing scenarios.

---

## Attack Contracts

### ReentrancyAttack Contract

The `ReentrancyAttack.sol` contract demonstrates how an attacker can exploit the vulnerabilities in the `LenderPool.sol` contract on behalf of the owner. Here's a detailed explanation of the functions inside this contract:

1. **Flash Loan Attack**: The `flashLoanAttack` function in the `ReentrancyAttack.sol` contract is designed to execute a series of steps:
   - Borrow funds from the `LenderPool.sol` contract using a flash loan.
   - Withdraw the borrowed funds from the lending pool.
   - Borrow funds from the `FlashLoanReceiver.sol` contract using a flash loan.
   - Withdraw funds from the `FlashLoanReceiver.sol` contract along with the fee.
   - Send the stolen funds to the attacker.

2. **Execute Function**: The `execute` function in the `ReentrancyAttack.sol` contract is called when the attacker interacts with the `LenderPool.sol` contract. Depending on the provided value, it either:
   - Performs multiple flash loans to the `FlashLoanReceiver.sol` contract and deposits the stolen funds back into the `LenderPool.sol`.
   - Deposits funds into the lending pool along with the fee.

### What The Hacker Can Do

The attacker can execute the `flashLoanAttack` function in the `ReentrancyAttack.sol` contract. This will enable hackers to exploit the vulnerabilities within the `LenderPool.sol` by performing the following actions

1. Borrow a significant amount of ETH from the `LenderPool.sol` contract using flash loans.

2. Drain the Ether balance of the `LenderPool.sol` contract by repeatedly borrowing and not repaying the loans.

3. Borrow funds from the `FlashLoanReceiver.sol` contract and withdraw them, potentially emptying the `FlashLoanReceiver.sol` contract.

4. Combine the stolen funds from both the `LenderPool.sol` and the `FlashLoanReceiver.sol` contract.

5. Send the stolen funds to the attacker's address.

---

### IntegerUnderflowAttack Contract

The `IntegerUnderflowAttack.sol` contract illustrates how a malicious actor can take advantage of a weakness within the `LenderPoolOne.sol` contract, particularly within the `withdraw` function. Here's a comprehensive breakdown of the functionalities provided by the attacking contract:

1. **Inheriting from LenderPoolOne**: The `IntegerUnderflowAttack.sol` contract inherits from the `LenderPoolOne.sol` contract, which means it has access to all the functions and variables defined in the lending pool.

2. **Override the withdraw Function**: The `IntegerUnderflowAttack.sol` contract overrides the `withdraw` function from the lending pool. This allows it to customize the behavior of the `withdraw` function while still retaining the original function's signature.

3. **Integer Underflow**: Within the overridden `withdraw` function, the attacking contract execute an integer underflow. It does this by subtracting the `_amount` parameter from the `depositor.balance` without proper bounds checks.

   ```solidity
   depositor.balance -= _amount;
   ```

4. **Transfer Ether**: After executing the underflow, the `IntegerUnderflowAttack.sol` contract transfers the `_amount` of Ether to the message sender.

   ```solidity
   payable(msg.sender).transfer(_amount); 
   ```

### What The Hacker Can Do

A hacker can potentially exploit the vulnerability in the `IntegerUnderflowAttack.sol` contract to manipulate the `LenderPoolOne.sol` contract in various ways. Here's what a hacker might do:

1. **Artificially Inflate Balances**: By triggering an integer underflow in the `withdraw` function, the hacker can make a depositor's balance significantly larger than it should be. This can be done by requesting a withdrawal of an amount that exceeds the depositor's balance. The result of the underflow would be a very large positive balance.

2. **Unauthorized Withdrawals**: With the artificially inflated balance, the attacker can then initiate multiple withdrawals, potentially depleting the `LenderPoolOne.sol`contract's Ether balance, as they might be able to withdraw more Ether than what the pool should allow.

3. **Disrupt Functionality**: The hacker's actions could disrupt the normal functioning of the `LenderPoolOne.sol` contract by draining its Ether reserves, rendering it unable to provide flash loans and honor the claims of legitimate depositors.

4. **Influence Reward Calculations**: By manipulating their balance and the pool's balance snapshots, the attacker can influence the reward calculations in their favor, potentially receiving a disproportionate share of fees collected in the pool.

5. **Deplete the Pool**: The hacker might conduct a series of attacks that target the pool's Ether balance and effectively drain it of funds, making it insolvent and unable to meet its obligations.

---

## Attack Testing

### Reentrancy Attack Test

To Run an Rentrancy attack test:

```bash
npx hardhat test test/ReentrancyAttackTest.js
```

---

### IntegerUnderflow Attack Test

To Run an Integer underflow attack test:

```bash
npx hardhat test test/IntegerUnderflowAttack.js
```

---

## FlashLoanReceiver Contract

The `FlashLoanReceiver.sol` contract is a smart contract designed to interact with a lending pool and participate in flash loans. This contract exhibits multiple significant vulnerabilities that could potentially be exploited, thereby jeopardizing the contract's integrity. These vulnerabilities and their associated risks are outlined below:

1. **Unauthorized Access**: The contract relies solely on checking the sender's address to ensure that flash loans can only be initiated by the lending pool. This access control mechanism is vulnerable to address spoofing and may allow external actors to execute flash loans.

2. **Insufficient Balance Check**: The contract checks if it has enough Ether balance to repay the flash loan after receiving funds. However, this check doesn't consider any potential external factors that could change the contract's balance between the loan request and repayment, leaving room for exploits.

3. **Custom Logic Vulnerability**: The `_executeActionDuringFlashLoan` function is intended for custom logic execution during flash loans. The presence of custom logic makes it more susceptible to the insertion of malicious code or the execution of actions that can compromised the contract's integrity.

---

***Will be updated soon***
