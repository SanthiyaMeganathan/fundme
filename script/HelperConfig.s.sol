//SPDX-License-Identifier: MIT

pragma solidity 0.8.27;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
import {console} from "forge-std/console.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract HelperConfig is Script {
    uint8 public DECIMAL;
    int256 public INITIAL_VALUE;

    //if we are on a local anvil, we deploy mocks
    //otherwise , grab the existing address from live network
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed; //eth/usd
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        //price feed address
        NetworkConfig memory sepolliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepolliaConfig;
    }

    function getAnvilEthConfig() public returns (NetworkConfig memory) {
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMAL,
            INITIAL_VALUE
        );

        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;

        //price feed address
    }

    function getMainnetEthConfig() public view returns (NetworkConfig memory) {
        //price feed address
        NetworkConfig memory mainnetConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            mainnetConfig.priceFeed
        );

        // Get the version of the price feed
        uint256 version = priceFeed.version();

        // Log the version to the console
        console.log("Price Feed Version:", version);

        return mainnetConfig;
    }
}
