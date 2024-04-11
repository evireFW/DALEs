import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

import multisigReleaseMetadata from "../../../contracts/plugins/governance/multlsig/release-metadata.json";
import multisigBuildMetadata from "../../../contracts/plugins/governance/multlsig/build-metadata.json";
import { createPluginRepo, uploadToIPFS } from "../../helpers";
import { ethers } from "ethers";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  console.log(`\nCreating plugin repos.`);

  console.warn(
    "Please make sure pluginRepo is not created more than once with the same name."
  );

  //   const { network } = hre;

  // MultisigSetup
  //   const multisigReleaseCIDPath = await uploadToIPFS(
  //     JSON.stringify(multisigReleaseMetadata),
  //     network.name
  //   );
  //   const multisigBuildCIDPath = await uploadToIPFS(
  //     JSON.stringify(multisigBuildMetadata),
  //     network.name
  //   );

  // Temporary use dummy paths
  const multisigReleaseCIDPath =
    "QmNnobxuyCjtYgsStCPhXKEiQR5cjsc3GtG9ZMTKFTTEFJ";
  const multisigBuildCIDPath = "QmNnobxuyCjtYgsStCPhXKEiQR5cjsc3GtG9ZMTKFTTEFJ";
  await createPluginRepo(
    hre,
    "multisig",
    "MultisigSetup",
    ethers.utils.hexlify(
      ethers.utils.toUtf8Bytes(`ipfs://${multisigReleaseCIDPath}`)
    ),
    ethers.utils.hexlify(
      ethers.utils.toUtf8Bytes(`ipfs://${multisigBuildCIDPath}`)
    )
  );
};
export default func;
func.tags = ["Create_Register_Plugins"];
