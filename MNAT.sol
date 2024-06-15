// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20FlashMint.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract MNAT is ERC20, Ownable, ERC20Permit, ERC20Votes, ERC20FlashMint, Pausable, ReentrancyGuard {
    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public loanedBalance;
    mapping(address => uint256) public loanRequestTime;
    mapping(address => uint256) public loanedEscrowBalance;

    uint256 public constant LOAN_DURATION = 3 days;
    uint256 public pricePerToken = 1 ether; // Placeholder price per token

    event TokensStaked(address indexed user, uint256 amount);
    event TokensUnstaked(address indexed user, uint256 amount);
    event TokensLoaned(address indexed user, uint256 amount);
    event LoanRepaid(address indexed user, uint256 amount);
    event TokensBought(address indexed user, uint256 amount);

    constructor(address initialOwner)
        ERC20("MANA", "MNAT")
        ERC20Permit("MANA")
    {
        _mint(initialOwner, 333000000 * 10 ** decimals());
        transferOwnership(initialOwner); // Set initial owner
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function buyTokens() external payable nonReentrant {
        require(msg.value > 0, "Insufficient ETH sent");
        uint256 tokensToBuy = msg.value / pricePerToken;
        require(tokensToBuy <= balanceOf(owner()), "Not enough tokens available for sale");
        _transfer(owner(), msg.sender, tokensToBuy);
        emit TokensBought(msg.sender, tokensToBuy);
    }

    function stakeTokens(uint256 amount) external whenNotPaused {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        stakedBalance[msg.sender] += amount;
        _transfer(msg.sender, address(this), amount);
        emit TokensStaked(msg.sender, amount);
    }

    function unstakeTokens(uint256 amount) external whenNotPaused {
        require(stakedBalance[msg.sender] >= amount, "Insufficient staked balance");
        stakedBalance[msg.sender] -= amount;
        _transfer(address(this), msg.sender, amount);
        emit TokensUnstaked(msg.sender, amount);
    }

    function loanTokens(uint256 amount) external whenNotPaused {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        require(loanedBalance[msg.sender] == 0, "Existing loan must be repaid before requesting a new one");

        loanedBalance[msg.sender] += amount;
        loanRequestTime[msg.sender] = block.timestamp;
        loanedEscrowBalance[msg.sender] += amount;
        _transfer(msg.sender, address(this), amount);
        emit TokensLoaned(msg.sender, amount);
    }

    function repayLoan() external whenNotPaused {
        require(loanedBalance[msg.sender] > 0, "No existing loan to repay");
        require(block.timestamp < loanRequestTime[msg.sender] + LOAN_DURATION, "Loan duration expired");

        _transfer(address(this), msg.sender, loanedBalance[msg.sender]);
        uint256 repaidAmount = loanedBalance[msg.sender];
        loanedBalance[msg.sender] = 0;
        loanRequestTime[msg.sender] = 0;
        loanedEscrowBalance[msg.sender] = 0;
        emit LoanRepaid(msg.sender, repaidAmount);
    }

    function setPrice(uint256 newPrice) external onlyOwner {
        pricePerToken = newPrice;
    }

    function distributeReward(address to, uint256 amount) external onlyOwner {
        _mint(to, amount); // Example reward distribution
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20) {
        super._beforeTokenTransfer(from, to, amount);
        require(!paused(), "Token transfer is paused");
        require(
            loanedBalance[from] == 0 || block.timestamp < loanRequestTime[from] + LOAN_DURATION,
            "Loan duration expired"
        );
        require(
            loanedEscrowBalance[from] == 0 || block.timestamp < loanRequestTime[from] + LOAN_DURATION,
            "Loan duration expired"
        );
    }

    // Override functions to resolve conflicts
    function _afterTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _burn(address account, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._burn(account, amount);
    }

    function _mint(address account, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._mint(account, amount);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
