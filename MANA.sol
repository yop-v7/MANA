// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MANA {
    struct Vote {
        uint256 predictedPrice;
        uint256 stakedAmount;
        bool claimedReward;
    }

    struct VotingPeriod {
        uint256 startTime;
        uint256 totalStaked;
        mapping(address => Vote) votes;
        address[] participants;
        uint256 actualPrice;
        bool priceSet;
    }

    uint256 public constant VOTING_INTERVAL = 2 hours;
    uint256 public constant PAUSE_DURATION = 10 minutes;
    uint256 public constant WARNING_THRESHOLD = 10000 * 10**18; // Assuming MNAT has 18 decimals
    uint256 public nextVotingTime;
    address public oracle;
    address public owner;
    uint256 public votingPeriodId;
    IERC20 public mnatToken;

    mapping(uint256 => VotingPeriod) public votingPeriods;

    event TokensStaked(address indexed user, uint256 amount, uint256 predictedPrice);
    event RewardClaimed(address indexed user, uint256 reward);
    event HighStakeWarning(address indexed user, uint256 amount);

    modifier onlyOracle() {
        require(msg.sender == oracle, "Only oracle can call this function.");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    constructor(address _mnatToken) {
        owner = msg.sender;
        nextVotingTime = block.timestamp + VOTING_INTERVAL;
        votingPeriodId = 1;
        mnatToken = IERC20(_mnatToken);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    function setOracle(address _oracle) external onlyOwner {
        oracle = _oracle;
    }

    function stakeTokens(uint256 amount, uint256 predictedPrice) external {
        require(block.timestamp < nextVotingTime - PAUSE_DURATION, "Voting is paused.");
        require(amount > 0, "Amount must be greater than zero.");
        require(mnatToken.balanceOf(msg.sender) >= amount, "Insufficient balance.");
        require(mnatToken.allowance(msg.sender, address(this)) >= amount, "Allowance is not enough.");

        VotingPeriod storage period = votingPeriods[votingPeriodId];
        if (period.votes[msg.sender].stakedAmount == 0) {
            period.participants.push(msg.sender);
        }

        if (amount >= WARNING_THRESHOLD) {
            emit HighStakeWarning(msg.sender, amount);
        }

        mnatToken.transferFrom(msg.sender, address(this), amount);
        period.totalStaked += amount;
        period.votes[msg.sender] = Vote(predictedPrice, amount, false);

        emit TokensStaked(msg.sender, amount, predictedPrice);
    }

    function setActualPrice(uint256 price) external onlyOracle {
        require(block.timestamp >= nextVotingTime, "Voting period is still active.");
        
        VotingPeriod storage period = votingPeriods[votingPeriodId];
        require(!period.priceSet, "Price already set for this period.");
        
        period.actualPrice = price;
        period.priceSet = true;

        // Find the closest predictions
        uint256 closestDifference = type(uint256).max;
        for (uint256 i = 0; i < period.participants.length; i++) {
            address participant = period.participants[i];
            uint256 predictedPrice = period.votes[participant].predictedPrice;
            uint256 difference = predictedPrice > price ? predictedPrice - price : price - predictedPrice;
            if (difference < closestDifference) {
                closestDifference = difference;
            }
        }

        // Mark the closest predictions
        for (uint256 i = 0; i < period.participants.length; i++) {
            address participant = period.participants[i];
            uint256 predictedPrice = period.votes[participant].predictedPrice;
            uint256 difference = predictedPrice > price ? predictedPrice - price : price - predictedPrice;
            if (difference == closestDifference) {
                period.votes[participant].claimedReward = true; // Mark for reward distribution
            }
        }

        // Start new voting period
        votingPeriodId++;
        nextVotingTime = block.timestamp + VOTING_INTERVAL;
    }

    function distributeRewards(uint256 periodId) external onlyOwner {
        VotingPeriod storage period = votingPeriods[periodId];
        require(period.priceSet, "Actual price not set yet.");
        
        uint256 totalWinners = 0;
        for (uint256 i = 0; i < period.participants.length; i++) {
            address participant = period.participants[i];
            if (period.votes[participant].claimedReward) {
                totalWinners++;
            }
        }
        
        require(totalWinners > 0, "No winners to distribute rewards to.");

        uint256 rewardPerWinner = period.totalStaked / totalWinners;
        for (uint256 i = 0; i < period.participants.length; i++) {
            address participant = period.participants[i];
            if (period.votes[participant].claimedReward) {
                mnatToken.transfer(participant, rewardPerWinner);
                period.votes[participant].claimedReward = false; // Reset for future use
            }
        }
    }

    function claimReward(uint256 periodId) external {
        VotingPeriod storage period = votingPeriods[periodId];
        require(period.priceSet, "Actual price not set yet.");
        Vote storage userVote = period.votes[msg.sender];
        require(userVote.claimedReward, "Not eligible for reward or already claimed.");

        uint256 reward = period.totalStaked / period.participants.length; // Even distribution
        mnatToken.transfer(msg.sender, reward);
        userVote.claimedReward = false; // Reset for future use

        emit RewardClaimed(msg.sender, reward);
    }

    function calculateReward(VotingPeriod storage period, address user) internal view returns (uint256) {
        Vote storage userVote = period.votes[user];
        if (userVote.predictedPrice == period.actualPrice) {
            uint256 reward = (userVote.stakedAmount * period.totalStaked) / period.totalStaked; // Proportional reward
            return reward;
        }
        return 0;
    }
}
