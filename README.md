# UpgradeableProxy Contract

This project implements an upgradeable proxy contract in Solidity, allowing for the separation of data storage and contract logic. This enables future upgrades without losing stored data.

  Contract Purpose

The `UpgradeableProxy.sol` contract serves as a proxy for other smart contracts (implementation or logic contracts). Its primary purpose is to enable the upgradeability of smart contract logic without losing the data stored in the contract's storage. This is achieved by delegating function calls to an external implementation contract using `delegatecall`.

  Key Features Used

- Upgradeability: Allows for the replacement of the implementation contract with a new version, providing the ability to update contract logic and fix bugs without losing stored data.
- Admin Control: Restricts the ability to upgrade the implementation contract to a designated admin user, ensuring controlled updates.
- Data Preservation: The proxy contract maintains the storage, ensuring that data is preserved even after upgrades.
- `delegatecall`: A low-level Solidity function that executes code from another contract in the context of the calling contract, enabling the implementation contract to operate on the proxy's storage.

  Technical Concepts Used

- Proxy Pattern: A design pattern that separates the contract's logic from its data storage, allowing for upgradeability.
- `delegatecall`: A Solidity opcode that allows a contract to execute code from another contract in the context of the calling contract. This is crucial for upgradeability, as it allows the implementation contract to modify the proxy's storage.
- Assembly (Inline Assembly): Low-level code used within the `_delegate()` function to perform the `delegatecall` efficiently.
- Modifiers: Used to enforce access control, such as the `onlyAdmin` modifier.
- Events: Used to log important contract actions, such as upgrades.
- Fallback/Receive Functions: used to delegate any call to the implementation contract.

  Code Comments Explaining Major Logic

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract UpgradeableProxy {
    address public implementation; // Address of the current implementation contract
    address public admin;          // Address of the admin who can upgrade

    event Upgraded(address indexed newImplementation);

    constructor(address _implementation) {
        admin = msg.sender;
        implementation = _implementation;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can upgrade");
        _;
    }

    function upgrade(address newImplementation) external onlyAdmin {
        require(newImplementation != address(0), "Invalid address");
        implementation = newImplementation;
        emit Upgraded(newImplementation);
    }

    fallback() external payable {
        _delegate(implementation);
    }

    receive() external payable {
        _delegate(implementation);
    }

    function _delegate(address _impl) private {
        require(_impl != address(0), "Implementation not set");

        assembly {
            // Get free memory pointer
            let ptr := mload(0x40)
            // Copy calldata to memory
            calldatacopy(ptr, 0, calldatasize())
            // Perform delegatecall
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            // Get return data size
            let size := returndatasize()
            // Copy return data to memory
            returndatacopy(ptr, 0, size)

            // Revert or return based on delegatecall result
            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }
}