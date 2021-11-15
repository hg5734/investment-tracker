// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;
import "../AdapterStorage.sol";

abstract contract ProtocolAdapter is AdapterStorage {

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
