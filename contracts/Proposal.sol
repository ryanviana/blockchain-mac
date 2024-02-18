// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ProposalContract is Ownable {
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

    uint256 public nextProposalId;
    mapping(uint256 => Proposal) public proposals;

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

    constructor() Ownable(msg.sender) {
        nextProposalId = 1;
    }

    function createProposal(
        address _creator,
        uint256 _budget,
        string memory _campaignDetails,
        address _token,
        uint256 _milestoneThreshold
    ) public returns (uint256) {
        uint256 newProposalId = nextProposalId; // Store the current nextProposalId

        Proposal memory newProposal = Proposal({
            id: newProposalId,
            advertiser: msg.sender,
            creator: _creator,
            campaignDetails: _campaignDetails,
            budget: _budget,
            isAccepted: false,
            token: _token,
            isFunded: false,
            isActive: true,
            milestoneThreshold: _milestoneThreshold
        });

        proposals[newProposalId] = newProposal;

        emit ProposalCreated(
            newProposalId,
            msg.sender,
            _creator,
            _budget,
            _campaignDetails
        );

        nextProposalId++; // Increment the ID for the next proposal

        return newProposalId; // Return the new proposal ID
    }

    function acceptProposal(uint256 _proposalId) public {
        require(
            tx.origin == proposals[_proposalId].creator,
            "Only the creator can accept this proposal"
        );
        require(
            proposals[_proposalId].isAccepted == false,
            "Proposal already accepted"
        );
        proposals[_proposalId].isAccepted = true;
        proposals[_proposalId].isActive = true; // Mark the campaign as ended

        emit ProposalAccepted(_proposalId, tx.origin);
    }

    function rejectProposal(uint256 _proposalId) public {
        require(
            tx.origin == proposals[_proposalId].creator,
            "Only the creator can reject this proposal"
        );
        require(
            proposals[_proposalId].isAccepted == false,
            "Proposal already accepted"
        );
        delete proposals[_proposalId];
        emit ProposalRejected(_proposalId, tx.origin);
    }

    function getProposal(
        uint256 _proposalId
    ) public view returns (Proposal memory) {
        return proposals[_proposalId];
    }
}
