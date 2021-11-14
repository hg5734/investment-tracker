// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;

abstract contract ProtocolAdapter {
    struct Token {
        address token;
        int256 amount;
        uint8 decimals;
    }

    function getBalance(address token, address account)
        public
        virtual
        view
        returns (int256, uint8);

    function getUnclamedRewards(address token, address account)
        public
        virtual
        view
        returns (Token[] memory);
}
