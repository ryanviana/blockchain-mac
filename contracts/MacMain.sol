// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/IProposal.sol";
import "../interfaces/IPayment.sol";
import "../interfaces/IAccessControl.sol";

contract MacMain {
    IProposal public proposalContract;
    IPayment public paymentContract;
    IAccessControl public accessControlContract;

    constructor(
        address _proposalContractAddress,
        address _paymentContractAddress,
        address _accessControlContractAddress
    ) {
        proposalContract = IProposal(_proposalContractAddress);
        paymentContract = IPayment(_paymentContractAddress);
        accessControlContract = IAccessControl(_accessControlContractAddress);
    }

    // PROPOSAL FUNCTIONS
    function createProposal(
        address creator,
        uint256 budget,
        string memory campaignDetails,
        address token,
        uint256 milestoneThreshold
    ) public {
        require(
            accessControlContract.hasRole(
                accessControlContract.ADVERTISER_ROLE(),
                msg.sender
            ),
            "Caller is not an advertiser"
        );

        proposalContract.createProposal(
            creator,
            budget,
            campaignDetails,
            token,
            milestoneThreshold
        );
    }

    function acceptProposal(uint256 proposalId) public {
        require(
            accessControlContract.hasRole(
                accessControlContract.CREATOR_ROLE(),
                msg.sender
            ),
            "Caller is not a creator"
        );
        proposalContract.acceptProposal(proposalId);
    }

    function rejectProposal(uint256 proposalId) public {
        require(
            accessControlContract.hasRole(
                accessControlContract.CREATOR_ROLE(),
                msg.sender
            ),
            "Caller is not a creator"
        );
        proposalContract.rejectProposal(proposalId);
    }

    function getProposal(
        uint256 id
    ) public view returns (IProposal.Proposal memory) {
        return proposalContract.getProposal(id);
    }

    function hasRole(bytes32 role, address account) public view returns (bool) {
        return accessControlContract.hasRole(role, account);
    }

    function grantCreatorRole(address account) public {
        require(
            accessControlContract.hasRole(
                accessControlContract.ADVERTISER_ROLE(),
                msg.sender
            ),
            "Caller is an advertiser"
        );
        accessControlContract.grantRole(
            accessControlContract.CREATOR_ROLE(),
            account
        );
    }

    function grantAdvertiserRole(address account) public {
        require(
            accessControlContract.hasRole(
                accessControlContract.CREATOR_ROLE(),
                msg.sender
            ),
            "Caller is a creator"
        );
        accessControlContract.grantRole(
            accessControlContract.ADVERTISER_ROLE(),
            account
        );
    }
}
