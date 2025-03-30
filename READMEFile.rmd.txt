## MultiSig Wallet Contract

## Overview
The MultiSigWallet contract is a smart contract that enables secure and decentralized fund management. It requires at least 2 out of 3 designated owners to approve a transaction before it can be executed.

## Features
- Multi-Signature Approval: Transactions require at least 2 approvals before execution.
- Security Modifiers: Ensures only owners can initiate and approve transactions.
- Event Logging: Records transaction creation, approvals, and execution.
- Ether Deposit & Balance Retrieval: Allows funds to be added and queried.

## Contract Components

1. Owners & Required Approvals
- The contract has 
3 owners who can approve transactions.
- A transaction requires at least 
2 approvals to be executed.

 2.Transaction Structure
Each transaction includes:
- `to`: Recipient address.
- `amount`: Value to be sent.
- `approvals`: Number of approvals received.
- `executed`: Status of the transaction.

 3.Key Functions
a) Submit a Transaction
solidity
function submitTransaction(address _to, uint _amount) external onlyOwner;

- An owner can propose a transaction by specifying the recipient (`_to`) and the amount (`_amount`).

b) Approve a Transaction
solidity
function approveTransaction(uint _txId) external onlyOwner;

- Owners can approve transactions.
- Once at least 2 approvals are received, the transaction is executed automatically.

 c) Execute a Transaction
solidity
function executeTransaction(uint _txId) private;

- Transfers funds if the transaction meets approval and balance requirements.

d) Deposit Funds
solidity
function deposit() external payable;

- Allows users to send Ether to the contract.

e) Check Contract Balance
solidity
function getBalance() external view returns (uint);

- Retrieves the current balance of the contract.

## Events
- TransactionCreated: Emitted when a new transaction is submitted.
- TransactionApproved: Emitted when an owner approves a transaction.
- TransactionExecuted: Emitted when a transaction is successfully executed.

## Deployment Steps
1. Deploy the contract with 3 valid Ethereum addresses as owners.
2. Fund the contract using the `deposit()` function.
3. Owners can submit and approve transactions.
4. Transactions will execute automatically when 2 approvals are received.

## Security Considerations
- Only designated owners can interact with transaction functions.
- Reentrancy protection is inherent due to the execution flow.
- Ensure the contract has enough balance before approving high-value transactions.

The MultiSigWallet contract enhances security by requiring multiple signatures for fund transfers, making it ideal for decentralized fund management in DAOs, business partnerships, or secure group wallets.

