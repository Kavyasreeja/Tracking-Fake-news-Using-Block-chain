var CNBCNews = artifacts.require("./CNBCNews.sol");
var FakeNews = artifacts.require("./FakeNews.sol");

module.exports = function(deployer) {
  deployer.deploy(CNBCNews).then( () =>  deployer.deploy(FakeNews) )
 
};