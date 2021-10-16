// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;

contract AdapterRegistryStorage {
    bytes32[] _protocolAdapterNames;
    mapping(bytes32 => address) _protocolAdapterAddress;
    mapping(bytes32 => address[]) _protocolAdapterSupportedTokens;

    struct AdapterBalance {
        bytes32 protocolAdapterName;
        TokenBalance[] tokenBalances;
    }

    struct TokenBalance {
        address token;
        int256 amount;
    }
}
