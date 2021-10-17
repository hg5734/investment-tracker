// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;

import {ProtocolAdapter} from "../../ProtocolAdapter.sol";
import {IERC20} from "../../interface/IERC20.sol";

contract HFProtocolAdapter is ProtocolAdapter {
    function getBalance(address token, address account)
        public
        override
        view
        returns (int256)
    {
        return int256(IERC20(token).balanceOf(account));
    }
}
