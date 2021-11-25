// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

interface IFrax {
    function userStakedFrax(address account) external view returns (uint256);

    function earned(address account) external view returns (uint256);

    function lp_pool() external view returns (address);
}
