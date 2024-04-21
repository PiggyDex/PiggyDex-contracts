import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
dotenv.config();

const config: HardhatUserConfig = {
	solidity: {
		version: "0.7.6",
		settings: {
			optimizer: {
				enabled: true,
				runs: 1000,
			},
		},
	},
	networks: {
		conflux: {
			url: "https://evmtestnet.confluxrpc.com",
			accounts:
				process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
		},
	},
	sourcify: {
		enabled: false,
	},
	etherscan: {
		apiKey: {
			espaceTestnet: "espace",
		},
		customChains: [
			{
				network: "espaceTestnet",
				chainId: 71,
				urls: {
					apiURL: "https://evmapi-testnet.confluxscan.io/api/",
					browserURL: "https://evmtestnet.confluxscan.io/",
				},
			},
		],
	},
};

export default config;