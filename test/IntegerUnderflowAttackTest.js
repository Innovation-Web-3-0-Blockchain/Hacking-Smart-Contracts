// Importing the 'expect' function from the 'chai' library for assertion testing
const { expect } = require("chai");

// Importing the 'ethers' library from 'hardhat' for Ethereum smart contract interaction
const { ethers } = require("hardhat");

describe("Integer Underflow Attack", function () {
  let attacker;
  let lenderPoolOne;
  let owner;

  beforeEach(async function () {
    [owner, attacker] = await ethers.getSigners();

    // Deploy the LenderPoolOne  contract
    const LenderPoolOne = await ethers.getContractFactory("LenderPoolOne");
    lenderPoolOne = await LenderPoolOne.deploy();

    // Deploy the IntergerUnderflowAttack contract
    const IntergerUnderflowAttack = await ethers.getContractFactory("IntegerUnderflowAttack");
    attacker = await IntergerUnderflowAttack.deploy();

    // Deposit Ether into the LenderPoolOne contract
    await lenderPoolOne.connect(owner).deposit({ value: ethers.utils.parseEther("1.0") });
  });

  it("Exploit", async function () {
    // Test that the attack attempt results in a revert
    const initialBalance = await lenderPoolOne.depositors(owner.address).balance;
    const attackAmount = 2000; // An amount larger than the initial balance

    await expect(attacker.withdraw(attackAmount)).to.be.reverted;
  });

  it("LenderPoolOne Unaffected", async function () {
    // Test that the LenderPoolOne contract remains unaffected by the attack
    const lenderPoolOneBalanceBefore = await ethers.provider.getBalance(lenderPoolOne.address);

    // Attempt the attack
    const attackAmount = 2000;
    await expect(attacker.withdraw(attackAmount)).to.be.reverted;

    const lenderPoolOneBalanceAfter = await ethers.provider.getBalance(lenderPoolOne.address);

    // Check that the lenderPoolOne balance remains unchanged
    expect(lenderPoolOneBalanceAfter).to.equal(lenderPoolOneBalanceBefore);
  });
});
