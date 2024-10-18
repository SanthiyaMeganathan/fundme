//SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/Fundme.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundme is Script {
    // what  ever befire the start braodcast is not real tx but after the start broadcast its the real tx so we don't want to waste the gas so we put th helper confug before the broadcast
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        //for below line if we have many thing to return in struct we need to use (add eth,,,) but we have only one in struct in helperconfig do we didn't putany ,
        address ethUsdPricFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPricFeed);
        vm.stopBroadcast();
        return fundMe; // Return the instance
    }
}
