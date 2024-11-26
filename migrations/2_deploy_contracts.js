// migrations/2_deploy_contracts.js
const EnergyToken = artifacts.require("EnergyToken");
const EnergyTrading = artifacts.require("EnergyTrading");

module.exports = async function (deployer) {
  // Deploy EnergyToken (if necessary) with an initial supply, e.g., 1,000,000 tokens
  await deployer.deploy(EnergyToken, 1000000);
  const energyTokenInstance = await EnergyToken.deployed();
  

  // Deploy EnergyTrading without passing any parameters
  await deployer.deploy(EnergyTrading);
  const energyTradingInstance = await EnergyTrading.deployed();

  console.log(`EnergyToken deployed at: ${energyTokenInstance.address}`);
  console.log(`EnergyTrading deployed at: ${energyTradingInstance.address}`);
};
