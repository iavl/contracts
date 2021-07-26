// SPDX-License-Identifier: GPL-3.0

pragma solidity =0.6.12;

contract Sub {
    uint256 public a;
    uint256 public b;
    function initialize(uint256 _a, uint256 _b) external {
        a = _a;
        b = _b;
    }
}

contract Main {

    address public subAddress;

    event Created(address addr);

    function createSub(uint256 a, uint256 b) public returns (address addr) {
        bytes memory bytecode = type(Sub).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(a, b));
        assembly {
            addr := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        Sub(addr).initialize(a, b);
        subAddress = addr;

        emit Created(addr);
    }
}
