// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;

abstract contract ProtocolAdapter {
    function getBalance(address token, address account) public virtual returns (int256);
}
