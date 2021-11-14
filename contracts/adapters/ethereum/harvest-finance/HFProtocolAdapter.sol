// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;

import {ProtocolAdapter} from "../../ProtocolAdapter.sol";
import {IHarvest} from "../../interface/IHarvest.sol";
import {IERC20} from "../../interface/IERC20.sol";

contract HFProtocolAdapter is ProtocolAdapter {
    function getBalance(address token, address account)
        public
        override
        view
        returns (int256, uint8)
    {
        address lpToken = address(IHarvest(token).lpToken());
        return (
            int256(IHarvest(token).balanceOf(account)),
            uint8(IERC20(lpToken).decimals())
        );
    }

    function getUnclamedRewards(address token, address account)
        public
        override
        view
        returns (Token[] memory)
    {
        Token[] memory rewards = new Token[](1);
        address rewardToken = IHarvest(token).rewardToken();
        rewards[0] = Token({
            token: rewardToken,
            amount: int256(IHarvest(token).earned(account)),
            decimals: uint8(IERC20(rewardToken).decimals())
        });
        return rewards;
    }
}
