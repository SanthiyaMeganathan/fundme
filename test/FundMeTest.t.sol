// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/Fundme.sol";

contract FundMeTest is Test {
    FundMe fundme;

    function setUp() external {
        fundme = new FundMe();
    }

    function testMinimumDollarIsFiver() public view {
        // Call the function MINIMUM_USD() to get its value
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        console.log(msg.sender);
        console.log(fundme.i_owner());

        console.log(address(this));
        assertEq(fundme.i_owner(), address(this));
    }
}
