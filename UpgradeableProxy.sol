// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract UpgradeableProxy {
    address public implementation; // Current logic contract
    address public admin;          // Admin who can upgrade logic

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
            let ptr := mload(0x40) // Get free memory pointer
            calldatacopy(ptr, 0, calldatasize()) // Copy call data

            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }
}