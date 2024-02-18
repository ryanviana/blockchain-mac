const { expect } = require("chai");
const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const tokenAddress = "0xf5b8043ffa6427a62174399ffbba0009005e7270";
const mileStoneThreshold = 1000;
const budget = 1000000;
const campaignDetails = "Test Campaign";

describe("Proposal", function () {
  async function deployContract() {
    const [admin, advertiser, creator] = await ethers.getSigners();
    const Proposal = await ethers.getContractFactory("ProposalContract");
    const proposal = await Proposal.deploy();
    return { proposal, admin, advertiser, creator };
  }

  it("Should create a Proposal and set admin", async function () {
    const { proposal, admin, advertiser, creator } = await loadFixture(
      deployContract
    );
    expect(await proposal.owner()).to.equal(admin.address);
  });

  it("should create a new proposal", async function () {
    const { proposal, admin, advertiser, creator } = await loadFixture(
      deployContract
    );

    await proposal.createProposal(
      creator.address,
      budget,
      campaignDetails,
      tokenAddress,
      mileStoneThreshold
    );
    const proposalDetails = await proposal.getProposal(1);
    expect(proposalDetails.creator).to.equal(creator.address);
  });

  it("should approve a proposal", async function () {
    const { proposal, admin, advertiser, creator } = await loadFixture(
      deployContract
    );

    await proposal.createProposal(
      creator.address,
      budget,
      campaignDetails,
      tokenAddress,
      mileStoneThreshold
    );

    const proposalConnectedToCreator = proposal.connect(creator);
    await proposalConnectedToCreator.acceptProposal(1);

    const proposalDetails = await proposal.getProposal(1);
    expect(proposalDetails.isAccepted).to.equal(true);
  });

  it("should reject a proposal", async function () {
    const { proposal, admin, advertiser, creator } = await loadFixture(
      deployContract
    );

    await proposal.createProposal(
      creator.address,
      budget,
      campaignDetails,
      tokenAddress,
      mileStoneThreshold
    );

    // Connecting the contract to the creator signer before sending the transaction
    const proposalConnectedToCreator = proposal.connect(creator);
    await expect(proposalConnectedToCreator.rejectProposal(1))
      .to.emit(proposalConnectedToCreator, "ProposalRejected")
      .withArgs(1, creator.address);
  });

  it("should fail if someone other than the creator tries to reject a proposal", async function () {
    const { proposal, admin, advertiser, creator } = await loadFixture(
      deployContract
    );

    await proposal.createProposal(
      creator.address,
      budget,
      campaignDetails,
      tokenAddress,
      mileStoneThreshold
    );
    await expect(proposal.connect(admin).rejectProposal(1)).to.be.revertedWith(
      "Only the creator can reject this proposal"
    );
  });

  // it("should begin ads", async function () {
  //   const { proposal, admin, advertiser, creator } = await loadFixture(
  //     deployContract
  //   );

  //   const proposalConnectedToAdvertiser = proposal.connect(advertiser);
  //   await proposalConnectedToAdvertiser.createProposal(
  //     creator.address,
  //     budget,
  //     campaignDetails,
  //     tokenAddress,
  //     mileStoneThreshold
  //   );

  //   const proposalConnectedToCreator = proposal.connect(creator);
  //   await proposalConnectedToCreator.acceptProposal(1);

  //   await proposalConnectedToAdvertiser.beginAds(1);

  //   const proposalDetails = await proposal.getProposal(1);
  //   expect(proposalDetails.isActive).to.equal(true);
  // });

  // it("should end ads", async function () {
  //   const { proposal, admin, advertiser, creator } = await loadFixture(
  //     deployContract
  //   );

  //   const proposalConnectedToAdvertiser = proposal.connect(advertiser);
  //   await proposalConnectedToAdvertiser.createProposal(
  //     creator.address,
  //     budget,
  //     campaignDetails,
  //     tokenAddress,
  //     mileStoneThreshold
  //   );

  //   const proposalConnectedToCreator = proposal.connect(creator);
  //   await proposalConnectedToCreator.acceptProposal(1);

  //   await proposalConnectedToAdvertiser.beginAds(1);
  //   const proposalDetails = await proposal.getProposal(1);
  //   expect(proposalDetails.isActive).to.equal(true);

  //   await proposalConnectedToAdvertiser.endAds(1);
  //   const proposalDetailsAfterEnd = await proposal.getProposal(1);
  //   expect(proposalDetailsAfterEnd.isActive).to.equal(false);
  // });
});
