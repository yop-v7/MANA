import hardhat from "hardhat";
const { ethers } = hardhat;
import { expect } from "chai";

describe("MANA Smart Contract with MNAT Token", function () {
  let MNAT;
  let mnat;
  let MANA;
  let mana;
  let owner;
  let oracle;
  let addr1;
  let addr2;

  beforeEach(async function () {
    [owner, oracle, addr1, addr2] = await ethers.getSigners();

    // Deploy MNAT token
    MNAT = await ethers.getContractFactory("MNAT");
    mnat = await MNAT.deploy(owner.address);
    await mnat.deployed();

    // Deploy MANA contract
    MANA = await ethers.getContractFactory("MANA");
    mana = await MANA.deploy(mnat.address);
    await mana.deployed();

    // Transfer MNAT tokens to addr1 and addr2
    await mnat.transfer(addr1.address, ethers.utils.parseUnits("1000", 18));
    await mnat.transfer(addr2.address, ethers.utils.parseUnits("1000", 18));

    // Set the oracle address
    await mana.connect(owner).setOracle(oracle.address);
  });

  it("Should allow staking tokens", async function () {
    const stakeAmount = ethers.utils.parseUnits("100", 18);
    const predictedPrice = 100;

    // Approve MANA contract to spend addr1's MNAT tokens
    await mnat.connect(addr1).approve(mana.address, stakeAmount);

    // Stake tokens
    await mana.connect(addr1).stakeTokens(stakeAmount, predictedPrice);

    const period = await mana.votingPeriods(1);
    const [predictedPriceFromVote, stakedAmountFromVote, claimedReward] = await mana.getVote(1, addr1.address);

    expect(period.totalStaked).to.equal(stakeAmount);
    expect(stakedAmountFromVote).to.equal(stakeAmount);
    expect(predictedPriceFromVote).to.equal(predictedPrice);
  });

  it("Should allow setting the actual price and reward distribution", async function () {
    const stakeAmount = ethers.utils.parseUnits("100", 18);
    const predictedPrice = 100;
    const actualPrice = 100;

    // Approve and stake tokens from addr1
    await mnat.connect(addr1).approve(mana.address, stakeAmount);
    await mana.connect(addr1).stakeTokens(stakeAmount, predictedPrice);

    // Increase time and set the actual price
    await ethers.provider.send("evm_increaseTime", [2 * 60 * 60]);
    await ethers.provider.send("evm_mine");

    await mana.connect(oracle).setActualPrice(actualPrice);

    // Claim reward
    const initialBalance = await mnat.balanceOf(addr1.address);
    await mana.connect(addr1).claimReward(1);
    const finalBalance = await mnat.balanceOf(addr1.address);
    expect(finalBalance).to.be.above(initialBalance);
  });

  it("Should prevent non-oracle from setting the actual price", async function () {
    await expect(mana.connect(addr1).setActualPrice(100)).to.be.revertedWith("Only oracle can call this function.");
  });

  it("Should prevent claiming reward before actual price is set", async function () {
    const stakeAmount = ethers.utils.parseUnits("100", 18);

    await mnat.connect(addr1).approve(mana.address, stakeAmount);
    await mana.connect(addr1).stakeTokens(stakeAmount, 100);

    await expect(mana.connect(addr1).claimReward(1)).to.be.revertedWith("Actual price not set yet.");
  });

  it("Should prevent claiming reward twice", async function () {
    const stakeAmount = ethers.utils.parseUnits("100", 18);
    const actualPrice = 100;

    // Approve and stake tokens from addr1
    await mnat.connect(addr1).approve(mana.address, stakeAmount);
    await mana.connect(addr1).stakeTokens(stakeAmount, 100);

    // Increase time and set the actual price
    await ethers.provider.send("evm_increaseTime", [2 * 60 * 60]);
    await ethers.provider.send("evm_mine");

    await mana.connect(oracle).setActualPrice(actualPrice);

    // Claim reward
    await mana.connect(addr1).claimReward(1);
    await expect(mana.connect(addr1).claimReward(1)).to.be.revertedWith("Not eligible for reward or already claimed.");
  });

  it("Should emit a warning for high-stake amounts", async function () {
    const stakeAmount = ethers.utils.parseUnits("10000", 18); // Stake an amount higher than the warning threshold

    // Transfer additional tokens to addr1 to ensure sufficient balance
    await mnat.transfer(addr1.address, stakeAmount);

    // Approve and stake tokens from addr1
    await mnat.connect(addr1).approve(mana.address, stakeAmount);

    // Listen for the HighStakeWarning event
    const tx = await (await mana.connect(addr1).stakeTokens(stakeAmount, 100)).wait();
    const events = tx.events.filter(event => event.event === "HighStakeWarning");

    // Ensure that the HighStakeWarning event is emitted
    expect(events.length).to.equal(1);
    expect(events[0].args.user).to.equal(addr1.address);
    expect(events[0].args.amount).to.equal(stakeAmount);
  });
});
