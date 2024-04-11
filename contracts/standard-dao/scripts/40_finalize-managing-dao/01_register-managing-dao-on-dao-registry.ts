import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

import {
  getContractAddress,
  MANAGING_DAO_METADATA,
  uploadToIPFS,
} from "../helpers";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { getNamedAccounts, ethers, network } = hre;
  const { deployer } = await getNamedAccounts();

  // Get `managingDAO` address.
  const managingDAOAddress = await getContractAddress("DAO", hre);

  // Get `DAORegistry` address.
  const daoRegistryAddress = await getContractAddress("DAORegistry", hre);

  // Get `DAORegistry` contract.
  const daoRegistryContract = await ethers.getContractAt(
    "DAORegistry",
    daoRegistryAddress
  );
  // Register `managingDAO` on `DAORegistry`.
  const registerTx = await daoRegistryContract.register(
    managingDAOAddress,
    deployer
  );
  await registerTx.wait();
  console.log(
    `Registered the (managingDAO: ${managingDAOAddress}) on (DAORegistry: ${daoRegistryAddress}), see (tx: ${registerTx.hash})`
  );

  // Set Metadata for the Managing DAO
  const managingDaoContract = await ethers.getContractAt(
    "DAO",
    managingDAOAddress
  );

  const metadataCIDPath = await uploadToIPFS(
    JSON.stringify(MANAGING_DAO_METADATA),
    network.name
  );

  await managingDaoContract.setMetadata(
    ethers.utils.hexlify(ethers.utils.toUtf8Bytes(`ipfs://${metadataCIDPath}`))
  );
};
export default func;
func.tags = ["RegisterManagingDAO"];
