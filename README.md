# Blockchain MAC - Solidity Smart Contracts

![Solidity](https://img.shields.io/badge/Solidity-0.8.24-363636)
![Hardhat](https://img.shields.io/badge/Hardhat-2.20-yellow)
![Chainlink](https://img.shields.io/badge/Chainlink-Functions-375BD2)
![Avalanche](https://img.shields.io/badge/Avalanche-Fuji-E84142)

Solidity smart contracts for the **MAC (Media Ad Chain)** platform -- a decentralized pay-per-click advertising system built on Avalanche with Chainlink automation.

## Overview

MAC connects advertisers with content creators through on-chain advertising partnerships. Advertisers set budgets and CPM (Cost Per Mille) rates, creators accept or reject offers, and payments are automatically triggered when click milestones are reached -- all verified through Chainlink Functions and Automation.

## Architecture

```
MacMain (Facade)
  ├── AdvertismentContract   — Campaign creation, acceptance, and lifecycle
  ├── PaymentContract        — ERC20 token escrow and milestone-based payouts
  ├── MACAccessControl       — Role-based access (Admin, Advertiser, Creator)
  ├── ClickCountFunction     — Chainlink Functions for off-chain click verification
  └── ActiveAdsKeeper        — Chainlink Log Trigger Automation for active campaigns
```

## Features

- **Role-Based Access Control** — Admin, Advertiser, and Creator roles via OpenZeppelin AccessControl
- **Campaign Lifecycle** — Create, accept, reject, and end advertising campaigns
- **Milestone Payments** — Automatic payouts when click thresholds are reached
- **Chainlink Functions** — Off-chain click count verification via Chainlink DON
- **Chainlink Automation** — Log-triggered keeper monitors active ad events
- **Multi-Token Payments** — ERC20 token support for campaign funding and payouts
- **Refund Mechanism** — Advertisers can reclaim unused funds after campaign ends

## Tech Stack

- **Language:** Solidity ^0.8.24
- **Framework:** [Hardhat](https://hardhat.org/)
- **Network:** Avalanche Fuji Testnet (C-Chain)
- **Dependencies:**
  - [OpenZeppelin Contracts](https://www.openzeppelin.com/contracts) v5 — AccessControl, ERC20, ReentrancyGuard
  - [Chainlink Contracts](https://github.com/smartcontractkit/chainlink) — Functions, Automation

## Smart Contracts

| Contract | Description |
|---|---|
| `MacMain.sol` | Main facade coordinating all sub-contracts |
| `Advertisment.sol` | Campaign CRUD and state management |
| `Payment.sol` | ERC20 escrow, milestone payments, and refunds |
| `AccessControl.sol` | Role management (Admin, Advertiser, Creator) |
| `ClicksCountFunction.sol` | Chainlink Functions client for click verification |
| `ActiveAdsKeeper.sol` | Chainlink Log Trigger Automation keeper |
| `Token.sol` | Test ERC20 token for development |

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) >= 16
- [Hardhat](https://hardhat.org/)

### Installation

```bash
npm install
```

### Configuration

Create a `.env` file:

```env
PRIVATE_KEY=your_wallet_private_key
```

### Compile

```bash
npx hardhat compile
```

### Test

```bash
npx hardhat test
```

### Deploy

```bash
npx hardhat run scripts/deploy.js --network fuji
```
