// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;

import {ProtocolAdapter} from "../../ProtocolAdapter.sol";
import {IDoDo} from "../../interface/IDoDo.sol";
import {IERC20} from "../../interface/IERC20.sol";

contract DoDoProtocolAdapter is ProtocolAdapter {
    function getBalance(address token, address account)
        public
        override
        view
        returns (int256, uint8)
    {
        address lpToken = address(IDoDo(token)._TOKEN_());
        return (
            int256(IDoDo(token).balanceOf(account)),
            uint8(IERC20(lpToken).decimals())
        );
    }

    function getUnclamedRewards(address token, address account)
        public
        override
        view
        returns (Token[] memory)
    {
        IDoDo tokenObj = IDoDo(token);
        uint256 totalRewardsCount = tokenObj.getRewardNum();
        Token[] memory rewards = new Token[](totalRewardsCount);
        for (uint256 i = 0; i < totalRewardsCount; i++) {
            address rewardToken = IDoDo(token).getRewardTokenById(i);
            rewards[i] = Token({
                token: rewardToken,
                amount: int256(IDoDo(token).getPendingReward(account, i)),
                decimals: uint8(IERC20(rewardToken).decimals())
            });
        }
        return rewards;
    }
}
