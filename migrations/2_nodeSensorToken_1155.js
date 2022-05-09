const FactoryERC1155 = artifacts.require("FactoryERC1155");

module.exports = function(deployer){
  deployer.deploy(FactoryERC1155);
}