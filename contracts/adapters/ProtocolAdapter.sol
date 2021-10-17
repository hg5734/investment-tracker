// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;

abstract contract ProtocolAdapter {
    function getBalance(address token, address account) public view virtual returns (int256);
}
