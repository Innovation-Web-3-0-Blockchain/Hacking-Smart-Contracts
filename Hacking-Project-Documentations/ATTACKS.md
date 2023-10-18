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

## Integer Overflow Attack

An Integer overflow attack in smart contracts happens when an arithmetic operation on an integer variable exceeds the maximum (or minimum, in the case of signed integers) representable value for that variable type.

**LenderPoolOne.sol:**

1. Vurability

```solidity
// Vulnerable code snippet

```
DETAILS FOR THE VULNERABLE CODE SNIPPET

2. Solution 

```solidity
// Add safeguards in the contract



// Updated code snippet 


}
```

EXPLAINING SOLUTION

---

## Integer Underflow Attacks

An Integer underflow attack in smart contracts occurs when a subtraction operation causes an unsigned integer variable to become smaller than zero.

**LenderPoolOne.sol:**

1. Vurability

```solidity
// Vulnerable code snippet
uint _undebitedReward = _poolProportion * (FEE * _snapshots);
```
The vulnerable code snippet does not have appropriate checks and validations to ensure that `_poolProportion` and `_snapshots` are not zero or negative before performing the multiplication and does not handle such cases safely to prevent underflows.

2. Solution 

```solidity
// Add safeguards in the contract


// Updated code snippet 
function rewardBalance(address _depositorAddr) public view returns (uint256) {
    Depositor memory _depositor = depositors[_depositorAddr];
    uint sum;

    for (uint i = _depositor.lastUpdateLoanCount + 1; i <= loanCount; i++) {
        sum += poolBalanceSnapshots[i];
    }

    if (sum == 0 || _depositor.balance == 0) return 0;

    uint _snapshots = loanCount - _depositor.lastUpdateLoanCount;

    require(_snapshots > 0, "No snapshots since the last update");
    require(_poolProportion > 0, "Pool proportion must be greater than zero");

    uint _poolBalanceAverage = sum / _snapshots;

    uint _poolProportion = _depositor.balance / _poolBalanceAverage;

    uint _undebitedReward = _poolProportion * (FEE * _snapshots);

    return (_undebitedReward * _depositor.rewardDebt);
    }
```

The solution code includes two `require` statements to check if `_snapshots` and `_poolProportion` are greater than zero before proceeding with the calculation. This prevents integer underflow vulnerabilities by ensuring that both the divisor and multiplier are always greater than zero.

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
