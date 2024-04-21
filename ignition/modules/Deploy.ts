import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { ethers } from 'hardhat';

const WCFX_address = "0x2ed3dddae5b2f321af0806181fbfa6d049be47d8";
const NativeCurrencyLabelBytes = ethers.encodeBytes32String("WCFX");

module.exports = buildModule("PiggySwap", (m) => {
	const UniswapV3Factory = m.contract("UniswapV3Factory", []);
	const SwapRouter = m.contract("SwapRouter", [
		UniswapV3Factory,
		WCFX_address,
	]);
	const NFTDescriptor = m.library("NFTDescriptor");
	const NonfungibleTokenPositionDescriptor = m.contract("NonfungibleTokenPositionDescriptor", [WCFX_address, NativeCurrencyLabelBytes], {
		libraries: {
			NFTDescriptor,
		},
	});
	const NonfungiblePositionManager = m.contract("NonfungiblePositionManager", [UniswapV3Factory, WCFX_address, NonfungibleTokenPositionDescriptor]);
	return { UniswapV3Factory, SwapRouter, NFTDescriptor, NonfungibleTokenPositionDescriptor, NonfungiblePositionManager };
});
