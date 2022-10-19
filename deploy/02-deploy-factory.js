const { network } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = network.config.chainId;
  const factoryDeployer = await deploy("factory", {
    args: [],
    from: deployer,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });
  console.log(`Contract deployed @ ${factoryDeployer.address}`);
};

module.exports.tags = ["factoryDeployer"];
