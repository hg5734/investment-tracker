// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

interface IHarvest {
    function earned(address account) external view returns (uint256);

    function balanceOf(address) external view returns (uint256);

    function rewardToken() external view returns (address);

    function lpToken() external view returns (address);
}
