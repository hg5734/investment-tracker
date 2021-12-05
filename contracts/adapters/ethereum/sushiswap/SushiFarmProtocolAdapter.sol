// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;

import "@openzeppelin/contracts/access/Ownable.sol";
import {ProtocolAdapter} from "../../ProtocolAdapter.sol";
import {ISushiFarm} from "../../interface/ISushiFarm.sol";
import {IERC20} from "../../interface/IERC20.sol";

contract SushiFarmProtocolAdapter is ProtocolAdapter, Ownable {

    address constant poolAddress = 0xc2EdaD668740f1aA35E4D8f227fB8E17dcA888Cd;
    address constant rewardToken = 0x6B3595068778DD592e39A122f4f5a5cF09C90fE2;
    uint8 constant decimals = 18;

    mapping(address => uint256) public poolMapping;
    
    constructor() {
        uint256 totalPool =  getPoolLength();
        for(uint256 i=0; i< totalPool; i++) {
            address lpToken = getLpToken(i);
            poolMapping[lpToken] = i;
        }
    }

    function getPoolLength() public view returns(uint256) {
        return  3;//ISushiFarm(poolAddress).poolLength();
    }

    function getLpToken(uint256 pid) public view returns(address) {
         ISushiFarm.PoolInfo memory poolInfo = ISushiFarm(poolAddress).poolInfo(pid);
         return address(poolInfo.lpToken);
    }

    function addPool(uint256 pid) external onlyOwner {
        address lpToken = address(ISushiFarm(poolAddress).lpToken(pid));
        poolMapping[lpToken] = pid;
    }

    function getBalance(address token, address account)
        public
        override
        view
        returns (int256, uint8)
    {
        uint256 pid = poolMapping[token];
        ISushiFarm.UserInfo memory userInfo = ISushiFarm(poolAddress).userInfo(pid, account);
        return (
            int256(userInfo.amount),
            uint8(IERC20(token).decimals())
        );
    }

    function getUnclamedRewards(address token, address account)
        public
        override
        view
        returns (Token[] memory)
    {
        Token[] memory rewards = new Token[](1);
        uint256 pid = poolMapping[token];
        rewards[0] = Token({
            token: rewardToken,
            amount: int256(ISushiFarm(poolAddress).pendingSushi(pid, account)),
            decimals: decimals
        });

        return rewards;
    }
}
