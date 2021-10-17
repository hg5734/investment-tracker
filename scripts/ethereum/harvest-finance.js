const hre = require("hardhat");

async function main() {
    // Hardhat always runs the compile task when running scripts with its command
    // line interface.
    //
    // If this script is run directly using `node` you may want to call compile
    // manually to make sure everything is compiled
    // await hre.run('compile');
    const { getNamedAccounts } = hre;
    console.log('deployer address:', await getNamedAccounts())

    // We get the contract to deploy
    const HFadapter = await (await hre.ethers.getContractFactory("HFProtocolAdapter")).deploy();
    await HFadapter.deployed();
    console.log("HF_ADAPTER", HFadapter.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });