const StartupInvestorPlatform = artifacts.require("StartupInvestorPlatform");

module.exports = function (deployer) {
  deployer.deploy(StartupInvestorPlatform);
};
