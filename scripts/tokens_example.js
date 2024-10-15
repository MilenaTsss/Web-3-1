const { ethers } = require("hardhat");


async function main() {
    const token = await ethers.getContractFactory("MilenaTssERC20");
    const [owner, otherSigner] = await ethers.getSigners();
    console.log(owner.address, otherSigner.address)

    const contractAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3"
    const contract = token.attach(contractAddress);
    console.log(contract)

    await contract.transfer(otherSigner.address, 100_000);

    await contract.approve(otherSigner.address, 500);

    await contract.connect(otherSigner).transferFrom(owner.address, otherSigner.address, 500);

    await contract.connect(otherSigner).purchase({ value: 50_000 });

    console.log(await contract.balanceOf(owner.address));
    console.log(await contract.balanceOf(otherSigner.address));
}

// Execute the main function and handle errors
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });