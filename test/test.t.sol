pragma solidity >=0.6.2;
pragma experimental ABIEncoderV2;

import {Test, console} from "forge-std/Test.sol";
import {IUniswapV2Factory} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {IUniswapV2Pair} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";

contract TestScript is Test {
    IUniswapV2Factory public factory;
    IUniswapV2Router02 public router;
    IERC20 public WCFX = IERC20(0x2ED3dddae5B2F321AF0806181FBFA6D049Be47d8);
    IERC20 public USDT = IERC20(0x7d682e65EFC5C13Bf4E394B8f376C48e6baE0355);
    address public wallet0 = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address public wallet1 = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    function setUp() public {
        bytes memory factoryBytecode = abi.encodePacked(
            vm.getCode("UniswapV2Factory.sol:UniswapV2Factory"), abi.encode(vm.envAddress("FEE_TO_SETTER"))
        );
        address factoryAddress;
        assembly {
            factoryAddress := create(0, add(factoryBytecode, 0x20), mload(factoryBytecode))
            if iszero(extcodesize(factoryAddress)) { revert(0, 0) }
        }
        bytes memory routerBytecode = abi.encodePacked(
            vm.getCode("UniswapV2Router02.sol:UniswapV2Router02"),
            abi.encode(factoryAddress, vm.envAddress("WETH_address"))
        );
        address routerAddress;
        assembly {
            routerAddress := create(0, add(routerBytecode, 0x20), mload(routerBytecode))
            if iszero(extcodesize(routerAddress)) { revert(0, 0) }
        }

        // console.logAddress(factoryAddress);
        // console.logAddress(routerAddress);

        factory = IUniswapV2Factory(factoryAddress);
        router = IUniswapV2Router02(routerAddress);
    }

    function test() public {
        deal(address(WCFX), address(this), 2 ether);
        deal(address(USDT), address(this), 3 ether);
        WCFX.approve(address(router), 2 ether);
        USDT.approve(address(router), 3 ether);
        router.addLiquidity(address(WCFX), address(USDT), 2 ether, 3 ether, 1, 1, address(this), 3883483483488);
        IUniswapV2Pair pair = IUniswapV2Pair(factory.getPair(address(WCFX), address(USDT)));
        console.log(pair.totalSupply());
        console.log(pair.balanceOf(address(this)));
        require(
            pair.totalSupply() == pair.balanceOf(address(this)) + 1000, "totalSupply != balanceOf + burnning amount"
        );

        vm.startPrank(wallet0);
        deal(address(WCFX), address(wallet0), 2 ether);
        deal(address(USDT), address(wallet0), 3 ether);
        WCFX.approve(address(router), 2 ether);
        USDT.approve(address(router), 3 ether);
        router.addLiquidity(address(WCFX), address(USDT), 2 ether, 3 ether, 1, 1, address(wallet0), 3883483483488);
        vm.stopPrank();
        console.log(pair.totalSupply());
        console.log(pair.balanceOf(wallet0));
        require(
            pair.totalSupply() == pair.balanceOf(wallet0) + pair.balanceOf(address(this)) + 1000,
            "totalSupply != balanceOf + burnning amount"
        );

        vm.startPrank(wallet0);
        deal(address(WCFX), address(wallet0), 1 ether);
        deal(address(USDT), address(wallet0), 1 ether);
        WCFX.approve(address(router), 1 ether);
        USDT.approve(address(router), 1 ether);
        address[] memory path = new address[](2);
        path[0] = address(WCFX);
        path[1] = address(USDT);
        router.swapExactTokensForTokens(1 ether, 1 ether, path, wallet0, 3883483483488);
        console.log(WCFX.balanceOf(wallet0));
        console.log(USDT.balanceOf(wallet0));
    }
}
