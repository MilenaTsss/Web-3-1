async function main() {
    const token = await hre.ethers.getContractFactory("MilenaTssERC20");

    const contractAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3";
    const contract = await token.attach(contractAddress);

    console.log(await contract.queryFilter("Transfer"));
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });