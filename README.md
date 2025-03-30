* Staking Pool Smart Contract

* Overview

The StakingPool contract allows users to stake ERC-20 tokens and earn rewards based on a predefined Annual Percentage Rate (APR). This staking mechanism incentivizes long-term holding by penalizing early withdrawals through a slashing mechanism.

* Key Features

- Staking Mechanism: Users can stake their ERC-20 tokens to earn rewards.
- APR-Based Rewards: Rewards are calculated based on the Annual Percentage Rate (APR) set by the contract owner.
- Minimum Staking Period: Users must stake their tokens for a specified period to avoid penalties.
- Slashing Penalty: Early withdrawals incur a slashing percentage to discourage premature unstaking.
- Non-Reentrancy Protection: The contract uses OpenZeppelin's ReentrancyGuard to prevent reentrancy attacks.

 Contract Functionalities

* Staking

Users can stake a specific amount of ERC-20 tokens by calling:

solidity
stake(uint256 _amount)


- Transfers _amount tokens from the sender to the contract.
- Updates the user's staking details.
- Emits Staked event.

** Unstaking

Users can withdraw their staked tokens and rewards by calling:

solidity
unstake()


- Checks if the staking period has been met.
- Applies a slashing fee if unstaked too early.
- Transfers the user's staked amount and rewards back.
- Emits Unstaked event.

* Claiming Rewards

Users can claim only their rewards without unstaking by calling:

solidity
claimRewards()


- Calculates rewards based on the staking period and APR.
- Transfers the rewards to the user.
- Emits RewardsClaimed event.

** Internal Reward Calculation

Rewards are updated using:

solidity
updateRewards(address _staker)


- Calculates time-based rewards based on APR.
- Updates the user's accumulated rewards.

* Events

The contract emits the following events:

- Staked(address indexed user, uint256 amount): When a user stakes tokens.
- Unstaked(address indexed user, uint256 amount, uint256 rewards): When a user unstakes.
- RewardsClaimed(address indexed user, uint256 amount): When a user claims rewards.
- Slashed(address indexed user, uint256 amount, string reason): When a user is penalized for early unstaking.

* Technical Concepts Used

- ERC-20 Compliance: The contract interacts with ERC-20 tokens using OpenZeppelin's IERC20 interface.
- Ownable Pattern: The contract follows the Ownable pattern to allow only the owner to modify key parameters.
- Reentrancy Protection: Uses OpenZeppelin's ReentrancyGuard to secure fund withdrawals.
- Time-Based Calculations: Rewards are calculated using a time-based approach (block.timestamp).

* Gas Optimization Techniques

- Storage Optimization: Uses struct mapping (mapping(address => StakeInfo)) to minimize redundant storage operations.
- Efficient Reward Calculation: Calculates rewards only when necessary, reducing on-chain computation.
- Minimal Function Calls: Uses internal functions to avoid unnecessary external calls.

* Testing & Deployment

** Prerequisites

- Solidity ^0.8.0
- OpenZeppelin Contracts (IERC20, Ownable, ReentrancyGuard)
- Hardhat, Remix, or Truffle
- Ethereum test networks (e.g., Goerli, Sepolia)

** Deployment Steps

1. Deploy the contract with:
   solidity
   new StakingPool(address _stakingToken, uint256 _annualPercentageRate, uint256 _minimumStakingPeriod, uint256 _slashingPercentage)
   
2. Set allowances and approve the staking contract.
3. Stake tokens, claim rewards, and test different unstaking scenarios.

* Security Considerations

- Reentrancy Protection: Ensured via nonReentrant modifiers.
- Prevent Unauthorized Access: Only the contract owner can update staking parameters.
- Slashing Mechanism: Deters short-term speculative staking.
- No Direct ETH Transfers: Fallback function prevents accidental ETH deposits.

Prepared by : 
Abayisenga Shalom
24RP02680

