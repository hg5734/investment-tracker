// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

interface IDoDo {
    function getRewardTokenById(uint256 id)
        external
        view
        returns (address);

    function balanceOf(address account) external view returns (uint256);

    function getPendingReward(address account, uint256 id)
        external
        view
        returns (uint256);

    function getRewardNum() external view returns (uint256);

    function _TOKEN_() external view returns (address);
}
