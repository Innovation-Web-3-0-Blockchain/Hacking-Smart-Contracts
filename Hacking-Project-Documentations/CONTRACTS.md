# Contracts 


- [LenderPool Contract](#lenderpool-contract)
- [FlashLoan Receiver Contract](#flashloan-receiver-contract)
- [Attack Contracts](#attack-contracts)
   - [Reentrancy Attack Contract](#reentrancy-attack-contract)
   - [Integer Overflow Vulnerability Example Contract](#integer-overflow-vulnerability-example-contract)
   - [Integer Underflow Vulnerability Example Contract](#integerunderflow-vulnerability-example-contract)
   - [Uninitialized Storage Pointer Vulnerability Example Contract](#uninitialized-storage-pointer-vulnerability-example-contract)
   - [Denial of Service Vulnerability Example](#denial-of-service-vulnerability-example)

---

### LenderPool Contract 

The `LenderPool.sol` contract exposes several significant vulnerabilities that could be exploited to compromise the contract's security. These vulnerabilities and the risks they pose are outlined below:

1. **Reentrancy Vulnerability**: The `LenderPool.sol` contract does not use the reentrancy guard modifier `nonReentrant` for its external functions. This leaves it vulnerable to reentrancy attacks where malicious contracts can make recursive calls to external contracts and manipulate their state.

2. **Integer Overflow**: There is no check for integer overflow in various arithmetic operations, particularly when calculating rewards and updating balances. An attacker could potentially manipulate these values to exploit an overflow vulnerability.

3. **Unchecked External Calls**: The `execute` function in the `IFlashLoanEtherReceiver` interface is called without any checks or validations. If the receiving contract has malicious code or vulnerabilities, this contract could be exploited.

4. **Lack of Access Control**: There is no access control mechanism to restrict certain functions to authorized users only. Anyone can deposit, withdraw, or claim rewards, which could lead to misuse.

5. **Flash Loan Vulnerability**: The `flashLoan` function allows borrowing Ether without any collateral or checks. If a malicious contract repeatedly calls this function and doesn't repay the loan, it can drain the pool's funds.

---

## FlashLoan Receiver Contract

The `FlashLoanReceiver.sol` contract is a smart contract designed to interact with a lending pool and participate in flash loans. This contract exhibits multiple significant vulnerabilities that could potentially be exploited, thereby jeopardizing the contract's integrity. These vulnerabilities and their associated risks are outlined below:

1. **Unauthorized Access**: The contract relies solely on checking the sender's address to ensure that flash loans can only be initiated by the lending pool. This access control mechanism is vulnerable to address spoofing and may allow external actors to execute flash loans.

2. **Insufficient Balance Check**: The contract checks if it has enough Ether balance to repay the flash loan after receiving funds. However, this check doesn't consider any potential external factors that could change the contract's balance between the loan request and repayment, leaving room for exploits.

3. **Custom Logic Vulnerability**: The `_executeActionDuringFlashLoan` function is intended for custom logic execution during flash loans. The presence of custom logic makes it more susceptible to the insertion of malicious code or the execution of actions that can compromised the contract's integrity.

---

## Attack Contracts

---

### Reentrancy Attack Contract

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

### Testing

To Run an Rentrancy attack test:

```bash
npx hardhat test test/1_ReentrancyAttackTest.js
```

---

### Integer Overflow Vulnerability Example Contract

The `IntegerOverflowVulnerabilityExample` contract demonstrates an integer overflow vulnerability by lacking the necessary checks and validations

### What The Hacker Can Do

If a smart contract has an integer overflow vulnerability, a hacker can potentially exploit this vulnerability to their advantage. Here's what an attacker could do if they discover an integer overflow vulnerability in a contract:

1. An attacker can intentionally deposit a large amount of tokens into the contract, causing an integer overflow. This would make the contract's `balance` variable wrap around to a very small value, effectively granting the attacker a huge amount of tokens.

2. With an inflated `balance` due to integer overflow, the attacker can then withdraw more tokens than the contract actually holds. This can deplete the contract's balance and potentially disrupt its intended functionality.

3. Depending on the contract's logic and how it interacts with the `balance` variable, an attacker might manipulate the contract in unintended ways. For example, they could disrupt the contract's normal operations or trick it into processing transactions that it wouldn't normally approve.

### IntegerOverflow Attack Test

To Run an Integer overflow attack test:

```bash
npx hardhat test test/2_IntegerOverFlowVulnerabilityTest.js
```

---

### Integer Underflow Example Contract

The `IntegerUnderflowVulnerabilityExample.sol` contract illustrates a basic example of handling deposits and withdrawals. There's no mechanism to prevent integer underflow.

### What The Hacker Can Do

If a smart contract has an integer underflow vulnerability, it may lead to unintended behavior and exploitation. Here's what a hacker could potentially do with a smart contract that an integer underflow vulnerability: 

1. By repeatedly withdrawing more funds than they have in their account, an attacker can reduce their balance to zero and then potentially wrap the uint256 variable, causing it to underflow and become a very large positive value. This manipulation can give the attacker a large, undeserved balance.

2. Depending on how the contract handles the underflow, it's possible that an attacker could create a negative balance in their account. This could potentially allow them to withdraw more funds than they initially deposited, essentially stealing from the contract.

3. If the underflow is not properly handled, it could lead to a disruption in the contract's operation, affecting other users and the contract's overall functionality.

---

### Testing

To Run an Integer underflow attack test:

```bash
npx hardhat test test/3_IntegerUnderflowVulnerabilityTest.js
```

---

### Uninitialized Storage Pointer Vulnerability Example Contract

The `UninitializedStoragePointerVulnerabilityExample.sol` contract illustrates an uninitialized storage pointer vulnerability. This vulnerability arises when a contract declares a local variable in this case, `storedBalance` without explicitly initializing it and then performs operations using that variable.

### What The Hacker Can Do

If a smart contract contains an uninitialized storage pointer vulnerability, it can result in unintended behavior and create opportunities for exploitation. Here's how an attacker could take advantage of the vulnerability:

1. The uninitialized storage pointer may contain data from previous operations or even other contracts. An attacker could read this uninitialized data to gain insights into the contract's state, which may include sensitive information or other users' balances.

2. An attacker could use the uninitialized storage pointer to manipulate the `storedBalance` variable, affecting the balances of different users. They could artificially inflate their balance or reduce the balance of others, leading to potential financial losses for users of the contract.

3. If the uninitialized storage pointer vulnerability is part of a more complex contract, an attacker may exploit it to gain unauthorized access to certain parts of the contract, enabling them to execute privileged functions or change contract settings.

6. By carefully exploiting the uninitialized storage pointer and manipulating `storedBalance`, an attacker might be able to steal funds from the contract or other users.

---

### Testing

To Run an uninitialized storage pointer attack test:

```bash
npx hardhat test test/4_UninitializedStoragePointerVulnerabilityTest.js
```
---

### Denial of Service Vulnerability Example Contract

The `DenialOfServiceVulnerabilityExample.sol` contract demonstrates a vulnerability to a Denial of Service. The vulnerability arises from an inefficient piece of code within the contract's `addData` function. This code has a nested loop that consumes a large amount of computational resources (gas) for each data element added.

### What The Hacker Can Do

1. The hacker creates a transaction to invoke the `addData` function, passing an array with a large number of elements or invoking the function multiple times with large arrays. The larger the array and the number of invocations, the more gas is consumed.

2. The inefficient nested loop in the `addData` function consumes a substantial amount of gas for each iteration. By providing a large input array, the attacker can deplete the available gas limit for the transaction.

3. If the gas limit is exceeded, the transaction fails to complete, and the changes made by the transaction, such as updating `totalValue` and `data`, are reverted. This effectively disrupts the intended functionality of the contract.

4. If the attacker sends multiple such transactions, the contract may become unresponsive to other legitimate transactions because it is constantly running out of gas.

---

### Testing

To Run a denial of service attack test:

```bash
npx hardhat test test/5_DenialOfServiceVulnerabilityExampleTest.js
```

---

### Front Running Vulnerability Example Contract

The `FrontRunningVulnerabilityExample.sol` contract

### What The Hacker Can Do


---

### Testing

To Run a front running attack test:

```bash
npx hardhat test test/6_FrontRunningVulnerabilityExampleTest.js
```

---