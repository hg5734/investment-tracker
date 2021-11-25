// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;

import {ProtocolAdapter} from "../../ProtocolAdapter.sol";
import {IFrax} from "../../interface/IFrax.sol";
import {IERC20} from "../../interface/IERC20.sol";

contract FraxProtocolAdapter is ProtocolAdapter {
    function getBalance(address token, address account)
        public
        override
        view
        returns (int256, uint8)
    {
        return (
            int256(IFrax(token).userStakedFrax(account)),
            18
        );
    }

    function getUnclamedRewards(address token, address account)
        public
        override
        view
        returns (Token[] memory)
    {
        uint256 totalRewardsCount = 1;
        Token[] memory rewards = new Token[](totalRewardsCount);
        for (uint256 i = 0; i < totalRewardsCount; i++) {
            address rewardToken = address(0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0); //FXS token
            rewards[i] = Token({
                token: rewardToken,
                amount: int256(IFrax(token).earned(account)),
                decimals: uint8(IERC20(rewardToken).decimals())
            });
        }
        return rewards;
    }
}
