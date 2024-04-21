import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

module.exports = buildModule("PiggySwap", (m) => {
	const factory = m.contract("UniswapV3Factory", []);

	return { factory };
});
