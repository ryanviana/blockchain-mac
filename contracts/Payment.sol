// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "../interfaces/IProposal.sol";

contract PaymentContract is Ownable, ReentrancyGuard {
    IProposal private proposal;
    struct Payment {
        uint256 amount;
        address recipient;
        address tokenAddress;
        bool isPaid;
    }

    mapping(uint256 => Payment) public payments;
    mapping(uint256 => mapping(address => uint256)) public proposalFunds;

    uint256 public nextPaymentId;

    event PaymentCreated(
        uint256 indexed paymentId,
        uint256 amount,
        address indexed tokenAddress,
        address indexed recipient
    );
    event PaymentCompleted(
        uint256 indexed paymentId,
        address indexed recipient
    );
    event FundsDeposited(address indexed token, uint256 amount);
    event CampaignEnded(uint256 indexed id);

    constructor(address _proposalContractAddress) Ownable(msg.sender) {
        nextPaymentId = 1;
        proposal = IProposal(_proposalContractAddress);
    }

    function createPayment(
        address _recipient,
        uint256 _amount,
        address _tokenAddress
    ) external onlyOwner {
        require(_amount > 0, "Amount must be greater than 0");
        require(_tokenAddress != address(0), "Invalid token address");

        payments[nextPaymentId] = Payment({
            amount: _amount,
            recipient: _recipient,
            tokenAddress: _tokenAddress,
            isPaid: false
        });

        emit PaymentCreated(nextPaymentId, _amount, _tokenAddress, _recipient);
        nextPaymentId++;
    }

    // Function to execute a payment
    function executePayment(uint256 _paymentId) external nonReentrant {
        Payment storage payment = payments[_paymentId];

        require(
            payment.amount > 0,
            "Invalid payment ID or payment already completed"
        );
        require(!payment.isPaid, "Payment already processed");
        // require(
        //     proposal.isCampaignFunded(_proposalId),
        //     "Campaign is not funded"
        // );

        IERC20 paymentToken = IERC20(payment.tokenAddress);
        require(
            paymentToken.balanceOf(address(this)) >= payment.amount,
            "Insufficient token balance"
        );

        payment.isPaid = true;
        paymentToken.transfer(payment.recipient, payment.amount);

        emit PaymentCompleted(_paymentId, payment.recipient);
    }

    function refundUnusedFunds(uint256 proposalId) public {
        IProposal.Proposal memory currentProposal = proposal.getProposal(
            proposalId
        );

        require(
            msg.sender == currentProposal.advertiser,
            "Only the advertiser can request a refund"
        );

        // Assuming a single token per proposal for simplicity
        address tokenAddress = currentProposal.token;
        uint256 remainingFunds = proposalFunds[proposalId][tokenAddress];

        require(remainingFunds > 0, "No funds left to refund");

        IERC20(tokenAddress).transfer(
            currentProposal.advertiser,
            remainingFunds
        );

        // Reset the funds to zero after refund
        proposalFunds[proposalId][tokenAddress] = 0;

        // Emit an event or add additional logic if needed
    }

    function getPayment(
        uint256 _paymentId
    ) external view returns (Payment memory) {
        return payments[_paymentId];
    }

    function getBalance(address tokenAddress) public view returns (uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }
}
