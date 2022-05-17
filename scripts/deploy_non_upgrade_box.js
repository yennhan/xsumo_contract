// scripts/deploy_upgradeable_box.js
const { ethers, upgrades } = require('hardhat');

async function main () {
  const marketplace = await ethers.getContractFactory('XSumo');
  console.log('Deploying x-sumo...');
  const box = await marketplace.deploy();
  await box.deployed();
  console.log('XSumo deployed to:', box.address);
}

main();
