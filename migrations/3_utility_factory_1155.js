const UtilityFactoryERC1155 = artifacts.require("UtilityFactoryERC1155");

module.exports = function(deployer){
  deployer.deploy(UtilityFactoryERC1155);
}