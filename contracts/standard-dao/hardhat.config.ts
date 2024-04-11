import * as dotenv from "dotenv";

import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-ethers";
import "hardhat-contract-sizer";
import "@typechain/hardhat";
import "hardhat-deploy";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  defaultNetwork: "fuji",
  networks: {
    hardhat: {
      chainId: 1337,
      allowUnlimitedContractSize: true,
    },
    fuji: {
      url: process.env.AVALANCHE_FUJI_RPC || "",
      accounts: [
        process.env.PRIVATE_KEY || "0x90ad449DEb987A1f34D5127751874E9BBD223F2f",
      ],
    },
  },
  namedAccounts: {
    deployer: {
      default: "0x90ad449DEb987A1f34D5127751874E9BBD223F2f",
      fuji: "0x90ad449DEb987A1f34D5127751874E9BBD223F2f",
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
    deploy: "./scripts",
  },
};

export default config;
