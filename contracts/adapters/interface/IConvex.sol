// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

interface IConvex {
    function earned(address account) external view returns (uint256);

    function balanceOf(address) external view returns (uint256);

    function rewardToken() external view returns (address);

    function stakingToken() external view returns (address);

    function extraRewards(uint256) external view returns (address);

    function extraRewardsLength() external view returns (uint256) ;
}
