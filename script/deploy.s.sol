pragma solidity >=0.5.0;

import {Script, console} from "forge-std/Script.sol";
import {IUniswapV2Factory} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        bytes memory factoryBytecode = abi.encodePacked(
            vm.getCode("UniswapV2Factory.sol:UniswapV2Factory"), abi.encode(vm.envAddress("FEE_TO_SETTER"))
        );
        address factoryAddress;
        assembly {
            factoryAddress := create(0, add(factoryBytecode, 0x20), mload(factoryBytecode))
            if iszero(extcodesize(factoryAddress)) { revert(0, 0) }
        }
        console.logAddress(factoryAddress);
        IUniswapV2Factory factory = IUniswapV2Factory(factoryAddress);
        console.logBytes32(factory.getInitCodeHash());

        bytes memory routerBytecode = abi.encodePacked(
            vm.getCode("UniswapV2Router02.sol:UniswapV2Router02"),
            abi.encode(factoryAddress, vm.envAddress("WETH_address"))
        );
        address routerAddress;
        assembly {
            routerAddress := create(0, add(routerBytecode, 0x20), mload(routerBytecode))
            if iszero(extcodesize(routerAddress)) { revert(0, 0) }
        }
        console.logAddress(routerAddress);

        vm.stopBroadcast();
    }
}
