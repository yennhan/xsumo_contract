// scripts/deploy_upgradeable_box.js
const { ethers, upgrades } = require('hardhat');

async function main () {
  const BoxV2 = await ethers.getContractFactory('XSumo');
  console.log('Upgrading XSUMO...');
  await upgrades.upgradeProxy('0x42de19AF3F92d748B32EBb9Bfd4aADAf313eaFAe', BoxV2);
  // console.log(await upgrades.erc1967.getImplementationAddress('0x22f0697a90723033D189D981b8fBA51437c4959b')," getImplementationAddress")
  // console.log(await upgrades.erc1967.getAdminAddress('0xC08e0334683c6a2209Ae518baF74F3074BC4064D')," getAdminAddress")   
  console.log('XSUMO upgraded');
}


main();