import { ethers } from "hardhat";

async function main() {
  const electionContract = await ethers.deployContract("ElectionsFactory");

  await electionContract.waitForDeployment();

  console.log(`contract deployed to ${electionContract.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
