const hre = require("hardhat");

async function main() {
  const paymentsEsrow = await hre.ethers.deployContract('PaymentEscrow',{});

  await paymentsEsrow.waitForDeployment();
  
  console.log("Ajira Pay Finance Payment Escrow deployed to:", paymentsEsrow.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});