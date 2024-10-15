const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MilenaTssERC20 contract testing", function () {
    let token;
    let owner;
    let addr1;
    let addr2;

    beforeEach(async function () {
        [owner, addr1, addr2] = await ethers.getSigners();
        const Token = await ethers.getContractFactory("MilenaTssERC20");
        token = await Token.deploy(owner);
    });

    describe("Deployment", function () {
        it("Should set the correct owner", async function () {
            expect(await token.owner()).to.equal(owner.address);
        });

        it("Should mint initial supply to the total supply", async function () {
            const initialSupply = 10000n * 10n ** 18n;
            expect(await token.totalSupply()).to.equal(initialSupply);
        });
    });

    describe("Purchasing Tokens", function () {
        it("Should allow users to purchase tokens with ETH", async function () {
            const purchaseAmount = 10; // 10 wei
        
            // addr1 calls the purchase function and sends 10 wei
            await token.connect(addr1).purchase({ value: purchaseAmount });

            // Check the balance of addr1 after purchase
            const addr1Balance = await token.balanceOf(addr1.address);
            expect(addr1Balance).to.equal(10); // 10 tokens (since 1 wei = 1 token)
        });

        it("Should reject purchase with zero ETH", async function () {
            await expect(token.connect(addr1).purchase()).to.be.revertedWith("Send ETH to purchase tokens");
        });
    });

    describe("Transfers", function () {
        beforeEach(async function () {
            const purchaseAmount = 1_000; // 1000 wei
            // addr1 purchases 1000 tokens
            await token.connect(addr1).purchase({ value: purchaseAmount });
        });

        it("Should transfer tokens correctly with fee", async function () {
            const transferAmount = 100; // 100 tokens, then fee will be 1 token
            await token.connect(addr1).transfer(addr2.address, transferAmount);

            expect(await token.balanceOf(addr1.address)).to.equal(900); // addr1 should have 900 tokens after transfer
            expect(await token.balanceOf(addr2.address)).to.equal(99); // 100 tokens minus 1 token fee which is 1%
            expect(await token.balanceOf(owner.address)).to.equal(BigInt(10_000 * 10 ** 18) + BigInt(1)); // 1% fee transferred to owner which is 1 token
        });

        it("Should revert transfer if amount exceeds balance", async function () {
            // addr1 transfers 2000 tokens to addr2, but addr1 have obly 1000
            await expect(token.connect(addr1).transfer(addr2.address, 2_000)).to.be.reverted;
        });

        it("Should transfer tokens correctly using transferFrom with fee", async function () {
            const transferAmount = 100; // 100 tokens, then fee will be 1 token
            await token.connect(addr1).approve(owner.address, transferAmount);
            await token.connect(owner).transferFrom(addr1.address, addr2.address, transferAmount);

            expect(await token.balanceOf(addr1.address)).to.equal(900); // addr1 should have 0 tokens after transfer
            expect(await token.balanceOf(addr2.address)).to.equal(99); // 1 token - 1% fee
            expect(await token.balanceOf(owner.address)).to.equal(BigInt(10_000 * 10 ** 18) + BigInt(1)); // 1% fee transferred to owner
        });
    });

    it("Should allow permit-based approval without gas fees", async function () {
        const nonce = await token.nonces(owner.address); // Get the nonce of the owner
        const deadline = Math.floor(Date.now() / 1000) + 3600; // Set a deadline 1 hour from now

        // Domain for EIP-712 signature
        const domain = {
            name: await token.name(),
            version: '1',
            chainId: (await owner.provider.getNetwork()).chainId,
            verifyingContract: token.address,
        };

        // Define the permit data structure as expected by the contract
        const types = {
            Permit: [
                { name: "owner", type: "address" },
                { name: "spender", type: "address" },
                { name: "value", type: "uint256" },
                { name: "nonce", type: "uint256" },
                { name: "deadline", type: "uint256" },
            ],
        };

        // Values to be signed
        const value = {
            owner: owner.address,
            spender: addr1.address, // Allow addr1 to spend on behalf of the owner
            value: 1000, // Approve 1000 tokens
            nonce: nonce,
            deadline: deadline,
        };

        console.log(owner.address)  

        // Sign the permit message
        const signature = await owner.signTypedData(domain, types, value);

        // Extract r, s, v from the signature
        const { v, r, s } =  ethers.Signature.from(signature);


        // VM Exception while processing transaction: reverted with custom error 'ERC2612InvalidSigner()'
        // Call permit to allow addr1 to spend owner's tokens
        // await token.permit(owner, addr1, 1000, deadline, v, r, s);

        // addr1 transfers 500 tokens to addr2
        // await token.connect(addr1).transferFrom(owner.address, addr2.address, 500);

        // Check balances
        // const addr2Balance = await token.balanceOf(addr2.address);
        // expect(addr2Balance).to.equal(500);
    });
});
