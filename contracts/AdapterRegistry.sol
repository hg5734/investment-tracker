// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./AdapterRegistryStorage.sol";
import "./adapters/ProtocolAdapter.sol";

contract AdapterRegistry is Ownable, AdapterRegistryStorage {
    function addProtocolAdapter(
        bytes32 newProtocolAdapterName,
        address newProtocolAdapterAddress,
        address[] calldata newSupportedTokens
    ) external onlyOwner {
        require(newProtocolAdapterAddress != address(0), "PAM: zero[1]");
        require(
            _protocolAdapterAddress[newProtocolAdapterName] == address(0),
            "PAM: exists"
        );
        _protocolAdapterNames.push(newProtocolAdapterName);
        _protocolAdapterAddress[newProtocolAdapterName] = newProtocolAdapterAddress;
        _protocolAdapterSupportedTokens[newProtocolAdapterName] = newSupportedTokens;
    }

    function removeProtocolAdapter(bytes32 protocolAdapterName)
        external
        onlyOwner
    {
        require(
            _protocolAdapterAddress[protocolAdapterName] != address(0),
            "PAM: does not exist[1]"
        );

        uint256 length = _protocolAdapterNames.length;
        uint256 index = 0;
        while (_protocolAdapterNames[index] != protocolAdapterName) {
            index++;
        }

        if (index != length - 1) {
            _protocolAdapterNames[index] = _protocolAdapterNames[length - 1];
        }

        _protocolAdapterNames.pop();

        delete _protocolAdapterAddress[protocolAdapterName];
        delete _protocolAdapterSupportedTokens[protocolAdapterName];
    }

    function updateProtocolAdapter(
        bytes32 protocolAdapterName,
        address newProtocolAdapterAddress,
        address[] calldata newSupportedTokens
    ) external onlyOwner {

            address oldProtocolAdapterAddress
         = _protocolAdapterAddress[protocolAdapterName];
        require(
            oldProtocolAdapterAddress != address(0),
            "PAM: does not exist[2]"
        );
        require(newProtocolAdapterAddress != address(0), "PAM: zero[2]");

        if (oldProtocolAdapterAddress == newProtocolAdapterAddress) {
            _protocolAdapterSupportedTokens[protocolAdapterName] = newSupportedTokens;
        } else {
            _protocolAdapterAddress[protocolAdapterName] = newProtocolAdapterAddress;
            _protocolAdapterSupportedTokens[protocolAdapterName] = newSupportedTokens;
        }
    }

    function getSupportedTokens(bytes32 protocolAdapterName)
        public
        view
        returns (address[] memory)
    {
        return _protocolAdapterSupportedTokens[protocolAdapterName];
    }

    function getBalances(address account)
        external
        view
        returns (AdapterBalance[] memory)
    {
        AdapterBalance[] memory adapterBalances = getAdapterBalances(
            _protocolAdapterNames,
            account
        );
        // console.log("Sender balance is %s tokens", adapterBalances);
        (
            uint256 nonZeroAdapterBalancesNumber,
            uint256[] memory nonZeroTokenBalancesNumbers
        ) = getNonZeroAdapterBalancesAndTokenBalancesNumbers(adapterBalances);

        return
            getNonZeroAdapterBalances(
                adapterBalances,
                nonZeroAdapterBalancesNumber,
                nonZeroTokenBalancesNumbers
            );
    }

    function getAdapterBalances(
        bytes32[] memory protocolAdapterNames,
        address account
    ) public view returns (AdapterBalance[] memory) {
        uint256 length = protocolAdapterNames.length;
        AdapterBalance[] memory adapterBalances = new AdapterBalance[](length);

        for (uint256 i = 0; i < length; i++) {
            adapterBalances[i] = getAdapterBalance(
                protocolAdapterNames[i],
                getSupportedTokens(protocolAdapterNames[i]),
                account
            );
        }

        return adapterBalances;
    }

    function getAdapterBalance(
        bytes32 protocolAdapterName,
        address[] memory tokens,
        address account
    ) public view returns (AdapterBalance memory) {
        address adapter = _protocolAdapterAddress[protocolAdapterName];
        require(adapter != address(0), "AR: bad protocolAdapterName");

        uint256 length = tokens.length;
        TokenBalance[] memory tokenBalances = new TokenBalance[](tokens.length);

        for (uint256 i = 0; i < length; i++) {
            try
                ProtocolAdapter(adapter).getBalance(tokens[i], account)
            returns (int256 amount, uint8 decimals) {
                 Token[] memory rewards = ProtocolAdapter(adapter).getUnclamedRewards(tokens[i], account);
                tokenBalances[i] = TokenBalance({
                    token: tokens[i],
                    amount: amount,
                    decimals: decimals,
                    rewards:  rewards
                });
            } catch {
                console.log("error");
                tokenBalances[i] = TokenBalance({
                    token: tokens[i],
                    amount: 0,
                    decimals: 0,
                    rewards: new Token[](1)
                });
            }
        }
        return
            AdapterBalance({
                protocolAdapterName: protocolAdapterName,
                tokenBalances: tokenBalances
            });
    }

    function getNonZeroAdapterBalancesAndTokenBalancesNumbers(
        AdapterBalance[] memory adapterBalances
    ) internal pure returns (uint256, uint256[] memory) {
        uint256 length = adapterBalances.length;
        uint256 nonZeroAdapterBalancesNumber = 0;
        uint256[] memory nonZeroTokenBalancesNumbers = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            nonZeroTokenBalancesNumbers[i] = getNonZeroTokenBalancesNumber(
                adapterBalances[i].tokenBalances
            );
            if (nonZeroTokenBalancesNumbers[i] > 0) {
                nonZeroAdapterBalancesNumber++;
            }
        }
        return (nonZeroAdapterBalancesNumber, nonZeroTokenBalancesNumbers);
    }

    function getNonZeroTokenBalancesNumber(TokenBalance[] memory tokenBalances)
        internal
        pure
        returns (uint256)
    {
        uint256 length = tokenBalances.length;
        uint256 nonZeroTokenBalancesNumber = 0;
        for (uint256 i = 0; i < length; i++) {
            if (tokenBalances[i].amount > 0) {
                nonZeroTokenBalancesNumber++;
            }
        }
        return nonZeroTokenBalancesNumber;
    }

    function getNonZeroAdapterBalances(
        AdapterBalance[] memory adapterBalances,
        uint256 nonZeroAdapterBalancesNumber,
        uint256[] memory nonZeroTokenBalancesNumbers
    ) internal pure returns (AdapterBalance[] memory) {
        AdapterBalance[] memory nonZeroAdapterBalances = new AdapterBalance[](
            nonZeroAdapterBalancesNumber
        );
        uint256 length = adapterBalances.length;
        uint256 counter = 0;
        for (uint256 i = 0; i < length; i++) {
            if (nonZeroTokenBalancesNumbers[i] == 0) {
                continue;
            }
            nonZeroAdapterBalances[counter] = AdapterBalance({
                protocolAdapterName: adapterBalances[i].protocolAdapterName,
                tokenBalances: getNonZeroTokenBalances(
                    adapterBalances[i].tokenBalances,
                    nonZeroTokenBalancesNumbers[i]
                )
            });
            counter++;
        }
        return nonZeroAdapterBalances;
    }

    function getNonZeroTokenBalances(
        TokenBalance[] memory tokenBalances,
        uint256 nonZeroTokenBalancesNumber
    ) internal pure returns (TokenBalance[] memory) {
        TokenBalance[] memory nonZeroTokenBalances = new TokenBalance[](
            nonZeroTokenBalancesNumber
        );
        uint256 length = tokenBalances.length;
        uint256 counter = 0;
        for (uint256 i = 0; i < length; i++) {
            if (tokenBalances[i].amount == 0) {
                continue;
            }
            nonZeroTokenBalances[counter] = tokenBalances[i];
            counter++;
        }
        return nonZeroTokenBalances;
    }
}
