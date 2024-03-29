const { expect } = require("chai");

describe("Token contract", function () {
    let owner;
    let Arena;

    before(async function () {
        [owner,addr1] = await ethers.getSigners();
        console.log("Owner's address:", owner.address);
        Arena = await ethers.deployContract("AR", [1000]);

    });

    it("Deployment should assign the total supply of tokens to the owner", async function () {
        const ownerBalance = await Arena.balanceOf(owner.address);
        expect(await Arena.totalSupply()).to.equal(ownerBalance);
    });

    it("Should create a new player", async function(){
	    await expect(Arena.createPlayer("roko")).to.not.be.reverted;
	    await expect(Arena.createPlayer("roko")).to.be.revertedWith("Player already exists with this address")
	    await expect(Arena.connect(addr1).createPlayer("roko")).to.be.revertedWith("Name already taken")
	    const player = await Arena.players(owner.address)
	    expect(player.userName).to.equal("roko");
    });

});

