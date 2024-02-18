// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ClickManagerContract is Ownable {
    struct ClickData {
        uint256 totalClicks;
        uint256 lastMilestone;
        uint256 milestoneThreshold; // Individual milestone threshold for each campaign
    }

    // Mapping from campaign ID to its click data
    mapping(uint256 => ClickData) public campaignClicks;

    event ClicksUpdated(uint256 indexed campaignId, uint256 totalClicks);
    event MilestoneReached(uint256 indexed campaignId, uint256 milestone);

    constructor() Ownable(msg.sender) {}
    // Function to initialize a campaign with a specific click milestone

    function initializeCampaign(
        uint256 _campaignId,
        uint256 _milestoneThreshold
    ) public onlyOwner {
        require(
            _milestoneThreshold > 0,
            "Milestone threshold must be greater than 0"
        );
        campaignClicks[_campaignId] = ClickData(0, 0, _milestoneThreshold);
    }

    // Function to update click counts for a campaign
    function updateClicks(
        uint256 _campaignId,
        uint256 _clicks
    ) public onlyOwner {
        require(
            campaignClicks[_campaignId].milestoneThreshold > 0,
            "Campaign not initialized"
        );
        ClickData storage clickData = campaignClicks[_campaignId];
        clickData.totalClicks += _clicks;
        emit ClicksUpdated(_campaignId, clickData.totalClicks);

        // Check if the new total has reached the next milestone
        uint256 currentMilestone = clickData.totalClicks /
            clickData.milestoneThreshold;
        if (currentMilestone > clickData.lastMilestone) {
            clickData.lastMilestone = currentMilestone;
            emit MilestoneReached(_campaignId, currentMilestone);
            // Additional logic can be added here to interact with other contracts
            // e.g., triggering payments or notifications
        }
    }

    // Additional functions as needed
}
