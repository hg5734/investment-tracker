// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

interface ISushiFarm {

     struct UserInfo {
        uint256 amount;   
        uint256 rewardDebt;
    }

    struct PoolInfo {
        uint256 accSushiPerShare;
        uint256 lastRewardTime;
        uint256 allocPoint;
        address lpToken;
    }

    function pendingSushi(uint256, address) external view returns (uint256);

    function poolLength() external view returns (uint256) ;

    function poolInfo(uint256 pid) external view returns (ISushiFarm.PoolInfo memory);

    function userInfo(uint256 pid, address) external view returns (ISushiFarm.UserInfo memory);

    function lpToken(uint256) external view returns (address);

}
