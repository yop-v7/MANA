# MANA - A Community Directed Decentralized Price Prediction Market
--- --- ---

# Abstract
The concept of cryptocurrency has been in existence for around 40 years and has now become a significant asset for investors to consider. Cryptocurrencies enable tradable exchange without the involvement of a third party, leading many individuals to pursue cryptocurrency trading as a career. With tradable cryptocurrencies like Bitcoin, Ethereum, Solana, and more, it's increasingly possible for people with limited experience in cryptocurrency and investing to quickly acquire knowledge and skills in this field. This often leads to a deep interest in the financial markets. MANA is positioned as a platform for profitable trading and a community-driven marketplace. While other organizations have introduced features enabling users to make predictions and interact, MANA aims to welcome users of all experience levels to test their expertise. It's a place where users can vote on the price movements of cryptocurrencies.

# Project Overview
MANA is a decentralized platform leveraging blockchain technology to enable community-driven price predictions for various assets. Utilizing the MANA Token (MNAT), participants can vote on future price movements every two hours, stake their tokens, and earn rewards for accurate predictions. The MANA platform aims to harness collective intelligence for market analysis while providing all participants with a fair, transparent, and engaging experience. 

Price prediction is a valuable tool for traders and investors. Traditional methods often rely on expert analysis or algorithmic predictions, which can be biased or lack transparency. MANA offers a decentralized alternative, where community members contribute their insights to predict price movements, creating a collective intelligence that enhances market understanding.

# Voting Mechanism
Community members must submit their predictions on where the price of a specific asset will be every two hours. This continuous voting cycle ensures up-to-date and relevant predictions that reflect the latest market sentiments.

# Staking
To participate in voting, members must stake MNAT tokens. Staking serves as a commitment to their prediction and helps prevent spam or malicious activities. The amount staked reflects the voter's confidence in their prediction. By staking tokens, users contribute to a larger pool of staked tokens that are then distributed amongst voters with the most accuracy. To maximize potential gains, members will need to stake more tokens. In other words, the more you put in, the more you'll get out.

# Data Collection
The smart contract records all votes and the corresponding staked amounts, ensuring complete transparency and immutability of the voting process. This data is publicly accessible and verifiable by anyone. While the voting data is public, the identity of the voters remains pseudonymous, linked only to their wallet addresses, to maintain the utmost security and privacy possible. 

# Outcome Verification
At the end of each voting period (every two hours), an oracle retrieves the actual price data from a reliable source. The smart contract then verifies the outcome by comparing the actual price change to the community's predictions.

# Reward Distribution
Participants who make correct predictions about price movements receive rewards from the staked tokens. The rewards are distributed proportionally based on the amount staked, which encourages accurate predictions and active participation. Those who make incorrect predictions forfeit their staked tokens, which are then redistributed among the correct predictors.

# Security and Fairness
The smart contract ensures that the voting process is secure and tamper-proof. Utilizing a reliable oracle minimizes the risk of manipulation, maintaining the integrity of the prediction outcomes.

# Community Engagement
MANA aims to promote active community engagement by enabling members to actively participate in market predictions. This engagement not only provides valuable insights into market trends but also creates a gamified experience that is both educational and rewarding.

**Use Cases:**
1. Trading Signals: Traders can utilize the collective predictions as signals to inform their trading strategies.
2. Market Analysis: Analysts and researchers can use the aggregated data for market sentiment analysis.
3. Gamified Learning: Beginners in trading can learn about market dynamics in an engaging, low-risk environment.
--- --- ---
**Technical Details**

# Smart Contract
The MANA smart contract is built on the secure and stable Ethereum network, ensuring efficient and reliable execution of voting, staking, and reward distribution.  

# Oracle Integration
A robust and decentralized oracle system fetches accurate price data, ensuring the integrity and reliability of the outcome verification process. 

# Tokenomics
- Token Name: Mana Token
- Token Symbol: MNAT
- Total Supply: 333,000,000 MNAT
- MNAT tokens are used for staking, voting, and reward distribution within the MANA platform.

Please take note of the following planned token allocation:

- Founder's Allocation: 15% (49.95M MNAT)
- Development Fund: 15% (49.95M MNAT)
- Marketing and Partnerships: 10% (33.3M MNAT)
- Community and Ecosystem Incentives + Total Liquidy Pool: 60% (199.8M MNAT)
  
# Roadmap
- Q3 2024: Concept Development and White Paper Release
- Q4 2024: Smart Contract Development and Testing
- Q1 2025: Oracle Integration and Platform Beta Launch
- Q2 2025: Full Platform Launch and Community Building
- Q3 2025: Expansion to Additional Assets and Enhanced Features
___ ___ ___

# MANA - A Community Directed Decentralized Price Prediction Market

## Detailed Example

### Scenario Setup

- **Total participants:** 30,000
- **Each participant stakes:** 15 MNAT
- **Total MNAT staked per participant in USD:** 15 MNAT * $3 = $45
- **Total MNAT staked by all participants:** 30,000 participants * 15 MNAT = 450,000 MNAT
- **Total value staked in USD:** 450,000 MNAT * $3 = $1,350,000

### User Predictions and Stakes

- **cg798:** Predicted 61,000, staked 15 MNAT.
- **topgwannabe69:** Predicted 60,000, staked 15 MNAT.
- **gtc43:** Predicted 62,000, staked 15 MNAT.
- **awesomesauce456:** Predicted 60,500, staked 15 MNAT.

### Calculation of Accuracy

- **Actual Bitcoin price from Chainlink oracle:** 60,762.23

Using the formula for accuracy:

\[ \text{Accuracy} = \left| \frac{\text{Predicted Price} - \text{Actual Price}}{\text{Actual Price}} \right| \times 100 \]

- **cg798:** Accuracy = \(\left| \frac{61,000 - 60,762.23}{60,762.23} \right| \times 100 \approx 0.39\%\)
- **topgwannabe69:** Accuracy = \(\left| \frac{60,762.23 - 60,000}{60,762.23} \right| \times 100 \approx 1.26\%\)
- **gtc43:** Accuracy = \(\left| \frac{62,000 - 60,762.23}{60,762.23} \right| \times 100 \approx 2.03\%\)
- **awesomesauce456:** Accuracy = \(\left| \frac{60,762.23 - 60,500}{60,762.23} \right| \times 100 \approx 0.43\%\)

### Identifying Top 33%

- **Total participants to reward:** \(\left\lfloor 0.33 \times 30,000 \right\rfloor = 9,900\)

### Total Reward Pool Calculation

- **Total MNAT staked:** 450,000 MNAT

### Reward Distribution

We will distribute rewards to the top 33% participants based on their accuracy. The reward calculation will be proportional to the inverse of their accuracy score. Here’s how we do it:

#### Calculation Example for Top Players

- **Total Share of Top 33%:** Let's calculate the total share for simplicity.

\[ \text{Total Share} = \text{Accuracy of cg798} + \text{Accuracy of topgwannabe69} + \text{Accuracy of gtc43} + \text{Accuracy of awesomesauce456} \]
\[ \text{Total Share} = 0.39 + 1.26 + 2.03 + 0.43 = 4.11 \]

Now we calculate each participant’s share:

- **cg798's Share:** \(\frac{0.39}{4.11} \approx 0.094\)
- **topgwannabe69's Share:** \(\frac{1.26}{4.11} \approx 0.302\)
- **gtc43's Share:** \(\frac{2.03}{4.11} \approx 0.486\)
- **awesomesauce456's Share:** \(\frac{0.43}{4.11} \approx 0.103\)

#### Calculate Rewards

- **cg798:** Reward = 450,000 MNAT \(\times\) 0.094 \(\approx\) 42,300 MNAT
- **topgwannabe69:** Reward = 450,000 MNAT \(\times\) 0.302 \(\approx\) 135,900 MNAT
- **gtc43:** Reward = 450,000 MNAT \(\times\) 0.486 \(\approx\) 218,700 MNAT
- **awesomesauce456:** Reward = 450,000 MNAT \(\times\) 0.103 \(\approx\) 46,350 MNAT

These calculations distribute the rewards proportionally based on the accuracy of the predictions, ensuring that the top 33% participants receive rewards and that those with the highest accuracy get the most significant rewards.

## Technical Documentation for `MANA.sol` Contract

The `MANA.sol` contract is designed to facilitate a decentralized price prediction market using the MNAT token. Here is a detailed breakdown of its components and functionality:

### Key Components

- **VotingPeriod Struct:** Defines each voting period, including start time, total staked tokens, votes, participants, actual price, and price set status.
- **Vote Struct:** Stores individual votes, including predicted price, staked amount, and claimed reward status.
- **Constants:** Defines the voting interval (2 hours), pause duration (10 minutes), and warning threshold (10,000 MNAT).
- **State Variables:** Stores the next voting time, oracle address, owner address, current voting period ID, MNAT token instance, and Chainlink price feed instance.
- **Mappings:** Manages voting periods and user votes.

### Events

- **TokensStaked:** Emitted when a user stakes tokens.
- **RewardClaimed:** Emitted when a user claims their reward.
- **HighStakeWarning:** Emitted when a user stakes an amount above the warning threshold.
- **LiquidityDistributed:** Emitted when liquidity is distributed to the liquidity pool.

### Constructor

Initializes the contract with the MNAT token and Chainlink price feed addresses, setting the owner and initial voting time.

### Modifiers

- **onlyOracle:** Restricts access to oracle-specific functions.
- **onlyOwner:** Restricts access to owner-specific functions.

### Functions

- **transferOwnership:** Allows the owner to transfer contract ownership.
- **setOracle:** Allows the owner to set the oracle address.
- **stakeTokens:** Allows users to stake tokens and predict prices within the allowed timeframe.
- **getLatestPrice:** Retrieves the latest Bitcoin price from the Chainlink oracle.
- **setActualPrice:** Sets the actual Bitcoin price for the current voting period (only callable by the oracle).
- **calculateAccuracy:** Calculates the accuracy of a user's prediction.
- **claimReward:** Allows users to claim their rewards based on prediction accuracy.
- **calculateReward:** Calculates the reward based on staked amount and accuracy.
- **distributeLiquidity:** Distributes staked tokens to a liquidity pool at the end of each voting period.

### Example Use Case

1. **Staking Tokens:**
   - Users call `stakeTokens` to stake their MNAT tokens and submit their predicted Bitcoin price.
   - Example: `stakeTokens(15, 61000)`

2. **Setting Actual Price:**
   - The oracle calls `setActualPrice` to set the actual Bitcoin price at the end of the voting period.
   - Example: `setActualPrice()`

3. **Claiming Rewards:**
   - Users call `claimReward` to claim their rewards based on prediction accuracy.
   - Example: `claimReward(1)`

4. **Distributing Liquidity:**
   - The contract internally calls `distributeLiquidity` to transfer staked tokens to the liquidity pool.
   - Example: Internal call during reward distribution.

### NOTE

My goal for the MANA contract is to provide the ability to test the skills of the user, while also making money. The markets are already competitive enough, but with the "Lucky 33 protocol" (yes im calling it that), I think this will add a cherry on top. Especcially since it takes money to make money on exchanges. Imagine you log on one day, you stake 15 tokens and your payout is signifigantly larger than you even dreamed of!

Any who, imma go back to the code now, so bye 
