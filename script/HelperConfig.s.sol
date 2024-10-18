//SPDX-License-Identifier: MIT

pragma solidity 0.8.27;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

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
            activeNetworkConfig = getorCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        //price feed address
        NetworkConfig memory sepolliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepolliaConfig;
    }

    function getorCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMAL,
            INITIAL_PRICE
        );
        // MockV3Aggregator mockPriceFeed = new MockV3Aggregator(8, 2000e8); MAGIC NUMBER

        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;

        //price feed address
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        //price feed address
        NetworkConfig memory mainnetConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainnetConfig;
    }
}
