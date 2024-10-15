const { network } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account: ", deployer.address);

    const Token = await ethers.getContractFactory("MilenaTssERC1155");
    const token = await Token.deploy("base uri", deployer.address);
    console.log("Token deployed to: ", await token.address);
}


main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });