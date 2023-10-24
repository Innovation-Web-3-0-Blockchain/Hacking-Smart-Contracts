# Types Of Exploits

- [Reentrancy Attack](#reentrancy-attack)
- [Integer Overflow Attack](#integer-overflow-attack)
- [Integer Underflow Attack](#integer-underflow-attack)
- [Uninitialized Storage Pointer Attack](#uninitialized-storage-pointer-attack)
- [Denial of Service Attack](#denial-of-service-attack)
- [Front-Running Attack](#front-running-attack)
- [Unprotected Private Data](#unprotected-private-data)
- [Access Control Issues](#access-control-issues)
- [Malicious Code Injection](#malicious-code-injection)
- [Smart Contract Bugs](#smart-contract-bugs)
- [Oracle Exploitation](#oracle-exploitation)
- [Token Vulnerabilities](#token-vulnerabilities)

---

## Reentrancy Attack

In a Reentrancy attack, an attacker calls an external contract within the target contract before the state changes are finalized. This can allow them to repeatedly call the vulnerable contract and drain its funds.

**LenderPool.sol:**

1. Vurability

```solidity
// Vulnerable code snippet
contract LenderPool {    
}
```

The vulnerable code snippet does not include any access control mechanisms. Anyone can interact with the `LenderPool.sol` contract's functions and variables.

2. Solution 

```solidity
// At the beginning of the contract input
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// Updated code snippet
contract LenderPool is ReentrancyGuard {       
}
```

The solution code begins with an import statement that fetches the `ReentrancyGuard.sol` contract from the OpenZeppelin library. `ReentrancyGuard.sol` is a contract designed to protect against reentrancy attacks in Ethereum smart contracts.

---

## Integer Overflow Attack

An Integer overflow attack in smart contracts happens when an arithmetic operation on an integer variable exceeds the maximum (or minimum, in the case of signed integers) representable value for that variable type.

**IntegerOverflowVulnerabilityExample.sol:**

1. Vurability

```solidity
// Vulnerable code snippets
function deposit(uint256 amount) public {
    balance += amount;
}
```

The vulnerable code snippet does not offer reliable protection against integer overflow. While it aims to identify potential overflows by comparing the result of an addition with the original balance, this method is not entirely reliable.

2. Solution 

```solidity
// Updated code snippet 
function deposit(uint256 amount) public {
    require(balance + amount >= balance, "Deposit Failed");
}
```

The solution code adds a safety check to the deposit function to protect against integer overflow vulnerabilities. It ensures that the balance can only be updated if the addition of the amount does not lead to an overflow.

---

## Integer Underflow Attacks

An Integer underflow attack in smart contracts occurs when a subtraction operation causes an unsigned integer variable to become smaller than zero.

**IntegerUnderflowVulnerabilityExample.sol:**

1. Vurability

```solidity
// Vulnerable code snippet
function withdraw(uint256 amount) external returns (bool) {
    if (balances[msg.sender] >= amount) {
        balances[msg.sender] -= amount;
}
```

The vulnerable code snippet is not performing the check for integer underflows effectively. While it does compare the balance with the withdrawal amount to avoid withdrawing more than the balance, it doesn't explicitly prevent subtraction that might lead to underflows in certain situations

2. Solution 

```solidity
// Updated code snippet 
    function withdraw(uint256 amount) external returns (bool) {
        if (amount <= balances[msg.sender]) {
            balances[msg.sender] -= amount;

            require(payable(msg.sender).send(amount, "Transfer Failed"));
}
```

The solution code prevents integer underflow by checking whether the withdrawal amount is less than or equal to the user's balance before processing the withdrawal and ensures that the transfer is done safely, with proper error handling.

---

## Uninitialized Storage Pointer Attacks

Contracts use storage to persist data. If a contract's state variables are not initialized properly, an attacker can manipulate uninitialized variables to their advantage.

**Will be updated soon**

---

## Denial of Service Attacks

Attackers may flood a smart contract with transactions or calls to overwhelm its resources, making it unresponsive or costly to execute.

---

## Front-Running Attacks

Front-running involves observing pending transactions and inserting your own transaction to take advantage of price changes or other conditions before the original transaction is confirmed.

---

## Unprotected Private Data 

If sensitive data is not adequately protected within a smart contract, hackers can access it and use it for malicious purposes.

---

## Access Control Issues 

Contracts may have inadequate access control mechanisms, allowing unauthorized users or even hackers to perform actions they shouldn't.

---

## Malicious Code Injection 

Attackers may attempt to inject malicious code into a smart contract during development or deployment, leading to unintended behavior.

---

## Smart Contract Bugs 

Simple coding errors, logic flaws, or poor code quality can lead to vulnerabilities that attackers can exploit.

--- 

## Oracle Exploitation

Smart contracts that rely on external data sources (oracles) can be vulnerable if the oracle is compromised or manipulated.

---

## Token Vulnerabilities 

Tokens and token-based systems can have vulnerabilities, such as supply manipulation, minting of unauthorized tokens, or incorrect transfer functions.

---
