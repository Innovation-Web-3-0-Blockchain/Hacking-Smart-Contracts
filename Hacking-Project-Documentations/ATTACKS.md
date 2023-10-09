# Types Of Exploits

- [Reentrancy Attacks](#reentrancy-attacks)
- [Integer Overflow-Underflow Attacks](#integer-overflow-underflow-attacks)
- [Uninitialized Storage Pointer Attacks](#uninitialized-storage-pointer-attacks)
- [Denial of Service Attacks](#denial-of-service-attacks)
- [Front-Running Attacks](#front-running-attacks)
- [Unprotected Private Data](#unprotected-private-data)
- [Access Control Issues](#access-control-issues)
- [Malicious Code Injection](#malicious-code-injection)
- [Smart Contract Bugs](#smart-contract-bugs)
- [Oracle Exploitation](#oracle-exploitation)
- [Token Vulnerabilities](#token-vulnerabilities)

---

## Reentrancy Attacks 

In a reentrancy attack, an attacker calls an external contract within the target contract before the state changes are finalized. This can allow them to repeatedly call the vulnerable contract and drain its funds.

**LenderPool.sol:**

1. Vurability

```solidity
// Vulnerable code snippet
contract LenderPool { 
    uint256 public loanCount; 
    uint256 public constant FEE = 1 ether;
    mapping(address => Depositor) public depositors; 
    mapping(uint256 => uint256) public poolBalanceSnapshots; 

    struct Depositor {
        uint256 balance;                
        uint256 lastUpdateLoanCount;    
        uint256 rewardDebt;          
    }
```

The vulnerable code snippet does not include any access control mechanisms. Anyone can interact with the `LenderPool.sol` contract's functions and variables.

2. Solution 

```solidity
// At the beginning of the file input
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// Updated code snippet
contract LenderPool is ReentrancyGuard { 
    uint256 public loanCount; 
    uint256 public constant FEE = 1 ether;
    mapping(address => Depositor) public depositors; 
    mapping(uint256 => uint256) public poolBalanceSnapshots; 

    struct Depositor {
        uint256 balance;                
        uint256 lastUpdateLoanCount;    
        uint256 rewardDebt;          
    }
```
The solution code begins with an import statement that fetches the `ReentrancyGuard.sol` contract from the OpenZeppelin library. `ReentrancyGuard.sol` is a contract designed to protect against reentrancy attacks in Ethereum smart contracts.

---

## Integer Overflow-Underflow Attacks 

Smart contracts often deal with numeric values. Integer overflow or underflow can occur when an arithmetic operation exceeds the maximum or minimum representable value. Hackers can exploit this to manipulate contract state variables.

***Will be updated soon***

---

## Uninitialized Storage Pointer Attacks

Contracts use storage to persist data. If a contract's state variables are not initialized properly, an attacker can manipulate uninitialized variables to their advantage.


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
