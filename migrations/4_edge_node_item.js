const EdgeNodeItems = artifacts.require("EdgeNodeItems");

module.exports = function(deployer){
  deployer.deploy(EdgeNodeItems,"TestNodeContarct","https://ipfs.io/", ["PRESSURE","TEMPERATURE",], [10, 12]);
}