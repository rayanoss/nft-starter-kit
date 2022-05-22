// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const ContractNFT = await hre.ethers.getContractFactory("Nerds");
  const contractNFT = await ContractNFT.deploy("https://gateway.pinata.cloud/ipfs/QmTuceHxYy4uawmQf3tWoTFT72Yep1JoF1CzMuGp3BLbdv/hidden.json", "0x014a070128a59e606727aea9fc9911e1e7a959570378c3e781461e68f7c0ecc0", ["0x06b14f52c6880bE2a287003C02E6A1924290C33B"], [100]);

  await contractNFT.deployed();

  console.log("NFT deployed to:", contractNFT.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
