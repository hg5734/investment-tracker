// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

interface IYearn {
    function balanceOf(address account) external view returns (uint256);

    function token() external view returns (address);
}
