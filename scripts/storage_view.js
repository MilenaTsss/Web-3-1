const { ethers } = require("hardhat");

async function main() {
    const token = await ethers.getContractFactory("MilenaTssERC20");
    const contractAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3";
    const contract = await token.attach(contractAddress);
    
    console.log("MilenaTssERC20")
    for (let i = 0; i < 10; i++) {
        const storageValue = await ethers.provider.getStorage(contract, i);
        console.log(`Storage at slot ${i}: ${storageValue}`)
    }

    const token2 = await ethers.getContractFactory("MilenaTssERC721");
    const contractAddress2 = "0xe7f1725e7734ce288f8367e1bb143e90bb3f0512";
    const contract2 = await token2.attach(contractAddress2);
    
    console.log("MilenaTssERC721")
    for (let i = 0; i < 10; i++) {
        const storageValue = await ethers.provider.getStorage(contract2, i);
        console.log(`Storage at slot ${i}: ${storageValue}`)
    }

    const token3 = await ethers.getContractFactory("MilenaTssERC1155");
    const contractAddress3 = "0x9fe46736679d2d9a65f0992f2272de9f3c7fa6e0";
    const contract3 = await token3.attach(contractAddress3);
    
    console.log("MilenaTssERC1155")
    for (let i = 0; i < 10; i++) {
        const storageValue = await ethers.provider.getStorage(contract3, i);
        console.log(`Storage at slot ${i}: ${storageValue}`)
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });