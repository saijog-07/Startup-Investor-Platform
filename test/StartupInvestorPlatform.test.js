const StartupInvestorPlatform = artifacts.require("StartupInvestorPlatform");

contract("StartupInvestorPlatform", (accounts) => {
  const [founder, investor] = accounts;

  let instance;

  before(async () => {
    instance = await StartupInvestorPlatform.deployed();
  });

  it("should create a new startup", async () => {
    await instance.createStartup("DApp Venture", "A blockchain startup", 500, { from: founder });
    
    // Fetch startup details
    const startup = await instance.getStartupDetails(founder);

    assert.equal(startup[0], "DApp Venture", "Startup name should match");
    assert.equal(startup[1], "A blockchain startup", "Description should match");
    assert.equal(startup[2].toNumber(), 500, "Funding goal should match");
  });

  it("should allow investment in a startup", async () => {
    const investmentAmount = web3.utils.toWei("1", "ether");

    await instance.invest(founder, { from: investor, value: investmentAmount });

    // Fetch updated funds raised
    const startup = await instance.getStartupDetails(founder);
    assert.equal(startup[3].toString(), investmentAmount, "Funds raised should match investment");
  });
});
