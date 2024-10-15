const { network } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account: ", deployer.address);

    const Token = await ethers.getContractFactory("MilenaTssERC721");
    const token = await Token.deploy(deployer.address);
    console.log("Token deployed to: ", token.address);
}


main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });