// scripts/deploy_upgradeable_box.js
const { ethers, upgrades } = require('hardhat');

async function main () {
  const xsumo = await ethers.getContractFactory('XSumo');
  console.log('Deploying x-sumo...');
  const box = await upgrades.deployProxy(xsumo, [42],{ initializer: 'initialize' });
  await box.deployed();
  console.log(box.address," box(proxy) address")
  console.log(await upgrades.erc1967.getImplementationAddress(box.address)," getImplementationAddress")
  console.log(await upgrades.erc1967.getAdminAddress(box.address)," getAdminAddress")   
  console.log('x-sumo deployed to:', box.address);
}
main();