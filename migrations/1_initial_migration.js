// 1_initial_migration.js
const Migration = artifacts.require("./Migrations.sol");

module.exports = function (deployer) {
  deployer.deploy(Migration);
};