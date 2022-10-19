const { network } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = network.config.chainId;
  const kahootGame = await deploy("kahoot", {
    args: ["SpongeBob Quiz"],
    from: deployer,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });
  console.log(`Contract deployed @ ${kahootGame.address}`);
};

module.exports.tags = ["kahootGame"];
