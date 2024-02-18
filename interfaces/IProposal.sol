// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IProposal {
    struct Proposal {
        uint256 id;
        address advertiser;
        address creator;
        string campaignDetails;
        uint256 budget;
        bool isAccepted;
        address token;
        bool isFunded;
        bool isActive;
        uint256 milestoneThreshold;
    }

    event ProposalCreated(
        uint256 indexed id,
        address indexed advertiser,
        address indexed creator,
        uint256 budget,
        string campaignDetails
    );
    event CampaignEnded(uint256 indexed id);
    event ProposalAccepted(uint256 indexed id, address indexed creator);
    event ProposalRejected(uint256 indexed id, address indexed creator);

    function createProposal(
        address _creator,
        uint256 _budget,
        string memory _campaignDetails,
        address _token,
        uint256 _milestoneThreshold
    ) external returns (uint256);

    function acceptProposal(uint256 _proposalId) external;

    function rejectProposal(uint256 _proposalId) external;

    function getProposal(
        uint256 _proposalId
    ) external view returns (Proposal memory);

    // Any other public functions or variables that need to be accessed externally
}
