// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;
import "./AdapterStorage.sol";

contract AdapterRegistryStorage is AdapterStorage {
    bytes32[] public _protocolAdapterNames;
    mapping(bytes32 => address) public _protocolAdapterAddress;
    mapping(bytes32 => address[]) public _protocolAdapterSupportedTokens;

    struct AdapterBalance {
        bytes32 protocolAdapterName;
        TokenBalance[] tokenBalances;
    }

    struct TokenBalance {
        address token;
        int256 amount;
        uint8 decimals;
        Token[] rewards;
    }
}
