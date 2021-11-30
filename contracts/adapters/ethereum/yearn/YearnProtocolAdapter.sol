// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;

import {ProtocolAdapter} from "../../ProtocolAdapter.sol";
import {IYearn} from "../../interface/IYearn.sol";
import {IERC20} from "../../interface/IERC20.sol";

contract YearnProtocolAdapter is ProtocolAdapter {
    function getBalance(address token, address account)
        public
        override
        view
        returns (int256, uint8)
    {
        address lpToken = address(IYearn(token).token());
        return (
            int256(IYearn(token).balanceOf(account)),
            uint8(IERC20(lpToken).decimals())
        );
    }

    function getUnclamedRewards(address token, address account)
        public
        override
        view
        returns (Token[] memory)
    {
        Token[] memory rewards = new Token[](0);
        return rewards;
    }
}
