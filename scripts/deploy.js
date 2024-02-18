require("ethers");

async function main() {
  const Proposal = await ethers.deployContract("ProposalContract");
  await Proposal.waitForDeployment();
  const proposalAddress = Proposal.target;
  const Payment = await ethers.deployContract("PaymentContract", [
    proposalAddress,
  ]);
  await Payment.waitForDeployment();
  const paymentAddress = Payment.target;
  const AccessControl = await ethers.deployContract("MACAccessControl");
  await AccessControl.waitForDeployment();
  const accessControlAddress = AccessControl.target;
  const MACPlatformManager = await ethers.deployContract("MACPlatformManager", [
    proposalAddress,
    paymentAddress,
    accessControlAddress,
  ]);
  await MACPlatformManager.waitForDeployment();
  console.log("Proposal deployed to:", proposalAddress);
  console.log("Payment deployed to:", paymentAddress);
  console.log("AccessControl deployed to:", accessControlAddress);
  console.log("MACPlatformManager deployed to:", MACPlatformManager.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
