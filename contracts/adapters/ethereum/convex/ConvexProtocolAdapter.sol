// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;

import "hardhat/console.sol";
import {ProtocolAdapter} from "../../ProtocolAdapter.sol";
import {IConvex} from "../../interface/IConvex.sol";
import {IERC20} from "../../interface/IERC20.sol";

contract ConvexProtocolAdapter is ProtocolAdapter {
    function getBalance(address token, address account)
        public
        override
        view
        returns (int256, uint8)
    {
        address lpToken = address(IConvex(token).stakingToken());
        return (
            int256(IConvex(token).balanceOf(account)),
            uint8(IERC20(lpToken).decimals())
        );
    }

    function getUnclamedRewards(address token, address account)
        public
        override
        view
        returns (Token[] memory)
    {
        uint256 length = IConvex(token).extraRewardsLength();
        Token[] memory rewards = new Token[](length + 1);
        address rewardToken = IConvex(token).rewardToken();
        rewards[0] = Token({
            token: rewardToken,
            amount: int256(IConvex(token).earned(account)),
            decimals: uint8(IERC20(rewardToken).decimals())
        });
        for (uint256 i = 1; i <= length; i++) {
            rewardToken = IConvex(token).extraRewards(i - 1);
            address tokenAdd = IConvex(rewardToken).rewardToken();
            console.log(rewardToken);
            rewards[i] = Token({
                token: tokenAdd,
                amount: int256(IConvex(rewardToken).earned(account)),
                decimals: uint8(IERC20(tokenAdd).decimals())
            });
        }
        return rewards;
    }
}
