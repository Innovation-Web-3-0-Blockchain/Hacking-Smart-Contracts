# Contracts 

- [LenderPool Contract](#lenderpool-contract)
- [FlashLoanReceiver Contract](#flashloanreceiver-contract)
- [Attack Contract](#uninitialized-storage-pointer-attacks)
- [Attack Test](#attack-test)

---

## LenderPool Contract

The `LenderPool.sol` contract exposes several significant vulnerabilities that could be exploited to compromise the contract's security. These vulnerabilities and the risks they pose are outlined below:

1. **Reentrancy Vulnerability**: The LenderPool contract does not use the reentrancy guard modifier (`nonReentrant`) for its external functions. This leaves it vulnerable to reentrancy attacks where malicious contracts can make recursive calls to external contracts and manipulate their state.

2. **Integer Overflow**: There is no check for integer overflow in various arithmetic operations, particularly when calculating rewards and updating balances. An attacker could potentially manipulate these values to exploit an overflow vulnerability.

3. **Unchecked External Calls**: The `execute` function in the `IFlashLoanEtherReceiver` interface is called without any checks or validations. If the receiving contract has malicious code or vulnerabilities, this contract could be exploited.

4. **Lack of Access Control**: There is no access control mechanism to restrict certain functions to authorized users only. Anyone can deposit, withdraw, or claim rewards, which could lead to misuse.

5. **Flash Loan Vulnerability**: The `flashLoan` function allows borrowing Ether without any collateral or checks. If a malicious contract repeatedly calls this function and doesn't repay the loan, it can drain the pool's funds.

---

## FlashLoanReceiver Contract

The `FlashLoanReceiver.sol` contract is a smart contract designed to interact with a lending pool and participate in flash loans. This contract exhibits multiple significant vulnerabilities that could potentially be exploited, thereby jeopardizing the contract's integrity. These vulnerabilities and their associated risks are outlined below:

1. **Unauthorized Access**: The contract relies solely on checking the sender's address to ensure that flash loans can only be initiated by the lending pool. This access control mechanism is vulnerable to address spoofing and may allow external actors to execute flash loans.

2. **Insufficient Balance Check**: The contract checks if it has enough Ether balance to repay the flash loan after receiving funds. However, this check doesn't consider any potential external factors that could change the contract's balance between the loan request and repayment, leaving room for exploits.

3. **Custom Logic Vulnerability**: The `_executeActionDuringFlashLoan` function is intended for custom logic execution during flash loans. The presence of custom logic makes it more susceptible to the insertion of malicious code or the execution of actions that can compromised the contract's integrity.

---

## Attack Contract

The `Attack.sol` demonstrates how an attacker can exploit the vulnerabilities in the `LenderPool.sol` contract on behalf of the owner. Here's a detailed explanation of the functions inside this contract:

1. **Flash Loan Attack**: The `flashLoanAttack` function in the `Attack.sol` contract is designed to execute a series of steps:
   - Borrow funds from the `LenderPool.sol` contract using a flash loan.
   - Withdraw the borrowed funds from the `LenderPool`.
   - Borrow funds from the `FlashLoanReceiver.sol` contract using a flash loan.
   - Withdraw funds from the `FlashLoanReceiver.sol` contract along with the fee.
   - Send the stolen funds to the attacker.

2. **Execute Function**: The `execute` function in the `Attack.sol` contract is called when the attacker interacts with the `LenderPool.sol` contract. Depending on the provided value, it either:
   - Performs multiple flash loans to the `FlashLoanReceiver.sol` contract and deposits the stolen funds back into the `LenderPool`.
   - Deposits funds into the `LenderPool` along with the fee.

### What The Hacker Can Do

The attacker can execute the `flashLoanAttack` function in the `Attack.sol` contract. This will enable them to exploit the vulnerabilities in the `LenderPool.sol` contract to perform the following actions:

1. Borrow a significant amount of ETH from the `LenderPool.sol` contract using flash loans.

2. Drain the Ether balance of the `LenderPool.sol` contract by repeatedly borrowing and not repaying the loans.

3. Borrow funds from the `FlashLoanReceiver.sol` contract and withdraw them, potentially emptying the `FlashLoanReceiver.sol` contract.

4. Combine the stolen funds from both the `LenderPool.sol` and the `FlashLoanReceiver.sol` contract.

5. Send the stolen funds to the attacker's address.

---

## Attack Test

To Run an attack test:

```bash
npx hardhat test test/Execute_Attack.js
```

---

***Will be updated soon***
