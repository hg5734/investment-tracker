// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;

contract AdapterStorage {
    struct Token {
        address token;
        int256 amount;
        uint8 decimals;
    }
}
