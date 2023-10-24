// Importing the 'expect' function from the 'chai' library for assertion testing
const { expect } = require("chai");

// Importing the 'ethers' library from 'hardhat' for Ethereum smart contract interaction
const { ethers } = require("hardhat");

describe("Reentrancy Attack", function () {
  let deployer, hacker;
  // Pool has 1000 ETH in balance
  const ETHER_IN_POOL = ethers.utils.parseEther('1000');

  // Receiver has 10 ETH in balance
  const ETHER_IN_RECEIVER = ethers.utils.parseEther('10');

  before(async function () {
    // Setup the test scenario //

    // Get the deployer and hacker accounts
    [deployer, hacker] = await ethers.getSigners();

    // Deploy the LenderPoolFactory and FlashLoanReceiverFactory contracts using the deployer account
    const LenderPoolFactory = await ethers.getContractFactory('LenderPool', deployer);
    const FlashLoanReceiverFactory = await ethers.getContractFactory('FlashLoanReceiver', deployer);

    // Deploy the LenderPool contract and deposit ETH into it
    this.pool = await LenderPoolFactory.deploy();
    await this.pool.deposit({ value: ETHER_IN_POOL });

    // Check if the pool's balance and fee match the expected values
    expect(await ethers.provider.getBalance(this.pool.address)).to.be.equal(ETHER_IN_POOL);
    expect(await this.pool.FEE()).to.be.equal(ethers.utils.parseEther('1'));

    // Deploy the FlashLoanReceiver contract and send ETH to it
    this.receiver = await FlashLoanReceiverFactory.deploy(this.pool.address);
    await deployer.sendTransaction({ to: this.receiver.address, value: ETHER_IN_RECEIVER });

    // Check if the receiver's balance matches the expected value
    expect(await ethers.provider.getBalance(this.receiver.address)).to.be.equal(ETHER_IN_RECEIVER);

    // Initialize the hacker's balance with 0.1 ETH
    await ethers.provider.send("hardhat_setBalance", [
      hacker.address,
      "0x16345785d8a0000", // 0.1 ETH
    ]);

    // Check if the hacker's initial balance matches the expected value
    this.hackerInitialEthBalance = await ethers.provider.getBalance(hacker.address);
    expect(await ethers.provider.getBalance(hacker.address)).to.equal(ethers.utils.parseEther('0.1'));
  });

  it('Exploit', async function () {
    // Perform the exploit by deploying the ReentrancyAttack contract and calling the flashLoanAttack function
    const AttackFactory = await ethers.getContractFactory('ReentrancyAttack', hacker)
    this.attack = await AttackFactory.deploy(this.pool.address, this.receiver.address)
    await this.attack.flashLoanAttack()
  });

  after(async function () {
    // Check the success conditions after the exploit //

    // Ensure that all ETH has been drained from the receiver and the pool
    expect(await ethers.provider.getBalance(this.receiver.address)).to.be.equal('0');
    expect(await ethers.provider.getBalance(this.pool.address)).to.be.equal('0');

    // We are not precisely verifying the final balance of the hacker,
    // as it can vary based on the gas costs incurred during the attack.
    // In a scenario with zero gas costs, the final balance would be the initial balance before 
    // the attack plus the amounts in ETHER_IN_POOL and ETHER_IN_RECEIVER.

    const hackerFinalEthBalance = await ethers.provider.getBalance(hacker.address);

    // Check if the hacker's final balance is greater than the initial balance
    expect(hackerFinalEthBalance).to.be.gt(this.hackerInitialEthBalance);

    // Log the final balance of the hacker for reference
    console.log(`${ethers.utils.formatEther(hackerFinalEthBalance)} is approx. ${
      +ethers.utils.formatEther(this.hackerInitialEthBalance) + +ethers.utils.formatEther(ETHER_IN_POOL) + +ethers.utils.formatEther(ETHER_IN_RECEIVER)
    }`)
  });
});
