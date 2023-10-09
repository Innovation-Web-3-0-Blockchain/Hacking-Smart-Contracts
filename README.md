# Hacking-Smart-Contracts

Welcome to the `Hacking-Smart-Contracts` repository. This project primarily aims to demonstrate ethical hacking on smart contracts used in decentralized applications (DApps). Although blockchain and smart contracts bring transparency and security advantages, they are not impervious to vulnerabilities and potential exploits. 

## Table of Contents

- [Verification and Security](#verification-and-security)
- [Commented Code](#commented-code)
- [Getting Started](#getting-started)
  - [Clone the Repository](#clone-the-repository)
  - [Install Dependencies](#install-dependencies)
- [Features](#features)
  - [Types Of Exploits](#types-of-exploits)
  - [Smart Contracts Hacking](#smart-contracts-hacking) 
- [Contributing](#contributing)
- [License](#license)
- [Future Updates](#future-updates)
- [Additional Ressources](#additionnal-ressources)

## Verification and Security

Each modification to this project undergoes a meticulous verification process and subsequent signing. This stringent approach guarantees the authenticity and integrity of our codebase. In case you encounter any modifications that lack appropriate verification, we strongly advise against cloning or utilizing them, as they might harbor malicious code.

## Commented Code

**Please take note:** Our codebase is meticulously documented with comprehensive comments, aimed at providing a clear understanding of the functionality of individual components.

## Getting Started

### Clone the Repository

To explore and interact with the `HackingSmartContracts` project, follow these steps:

1. Clone this repository to your local machine.

   ```bash
   git clone https://github.com/CyberAnon1010101/Blockchain-HackingSmartContracts.git 
   ```
### Install Dependencies

2. Ensure you have `node.js` and `npm` installed in your environment.
  
3. Install the necessary dependencies by running the following command in your terminal:

   ```bash
   npm install
   ```
   
## Features 

### Types Of Exploits

Decentralized applications heavily depend on smart contracts, and although they come with numerous advantages, they also bring forth distinctive security concerns. Here are some potential exploits that blackhat hackers might attempt:

   - Reentrancy Attacks 
   - Integer Overflow-Underflow Attacks
   - Uninitialized Storage Pointer Attacks
   - Denial of Service Attacks
   - Front-Running Attacks
   - Unprotected Private Data
   - Access Control Issues
   - Malicious Code Injection
   - Smart Contract Bugs
   - Oracle Exploitation
   - Token Vulnerabilities

   ***More will be added***

To gain a thorough and in-depth comprehension of potential hacker attacks, please consult our [Hacking Project Documentations](./Hacking-Project-Documentations/ATTACKS.md).

## Smart Contracts Hacking

In this project, we will explore various smart contracts related to potential hacker attacks. Each contract serves as an example of they can exploit vulnerabilities in smart contracts.

- **Reentrancy Attacks:** 

We will be using three contracts, to illustrate how hackers can leverage reentrancy attacks.`Attack.sol`, `FlashLoanReceiver.sol`, and `LenderPool.sol`.

- **Integer Overflow-Underflow Attacks** *(Update in Progress)* 

**More contracts and attack types will be added in the future.**

For a more detailed understanding of the vulnerabilities or functionality of each contract, please refer to our [Hacking Project Documentations](./Hacking-Project-Documentations/CONTRACTS.md).

## Contributing

Contributions to this project are welcome and encouraged. If you identify any bugs, have feature requests, or would like to improve the project, please open an issue or submit a pull request. We appreciate your interest and contributions.

## License

This project is licensed under the [MIT License](LICENSE).

## Future Updates

As blackhat hackers seek new ways to exploit smart contracts, we're dedicated to staying ahead in ethical hacking techniques. Expect ongoing enhancements, including advanced security guides, community input, interactive challenges, testing framework integration, real-world case studies, and regular updates.

## Additional Resources

### Smart Contracts Bug Bounties

1. **Ethereum (Blockchain)**
   - [Ethereum Bug Bounty Program](https://ethereum.org/ig/bug-bounty/)

2. **MakerDAO (Stablecoin)**
   - [MakerDAO Bug Bounty Program](https://security.makerdao.com/bug-bounty-program)

3. **Chainlink (Data Feeds)**
   - [Chainlink Bug Bounty Program](https://blog.chain.link/expanding-the-chainlink-bug-bounty-program/)

4. **Aave (Lending & Borrowing)**
   - [Aave Bug Bounty Program](https://github.com/aave/bug-bounty)

5. **Synthetix (Synthetic Assets)**
   - [Synthetix Bug Bounty Program](https://blog.synthetix.io/synthetix-bug-bounties/)

6. **Yearn Finance (Yield Aggregator)**
   - [Yearn Finance Bug Bounty Program](https://immunefi.com/bounty/yearnfinance/)

7. **OpenSea (NFT)**
   - [OpenSea Bug Bounty Program](https://opensea.io/blog/articles/openseas-bug-bounty-program)


