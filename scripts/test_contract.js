const { ethers, upgrades } = require('hardhat');

const XSumo = await ethers.getContractFactory("XSumo");
const xsumo = await XSumo.attach("0xBC69FBe04af6500C4c3884e7EA566671682a808d");

//XSumo DEV
// 0xBC69FBe04af6500C4c3884e7EA566671682a808d  box(proxy) address
// 0xE33F843d3a7AB4b576417cd0F99b614648Df2013  getImplementationAddress
// 0x0000000000000000000000000000000000000000  getAdminAddress
// x-sumo deployed to: 0xBC69FBe04af6500C4c3884e7EA566671682a808d

//XSUMO PROD
// Deploying x-sumo...
// 0x7D150D3eb3aD7aB752dF259c94A8aB98d700FC00  box(proxy) address
// 0x21a0774AaB7C44b89289f7F59422E6D5a28b0050  getImplementationAddress
// 0x0000000000000000000000000000000000000000  getAdminAddress
// x-sumo deployed to: 0x7D150D3eb3aD7aB752dF259c94A8aB98d700FC00