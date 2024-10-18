// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/Fundme.sol";
import {DeployFundme} from "../script/DeployFundme.s.sol";

contract FundMeTest is Test {
    FundMe fundme;

    function setUp() external {
        fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
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

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundme.getVersion();
        console.log("Price Feed Version:", version);
        // Change the expected version based on the actual price feed you're using
        uint256 expectedVersion = 4; // Assuming version 4 is the expected one for your setup
        assertEq(
            version,
            expectedVersion,
            "Price feed version does not match the expected version."
        );
    }
}
