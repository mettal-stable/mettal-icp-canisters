# Mettal ICP Canisters Deployment Guide

This document outlines the steps to deploy the Mettal ICP Canisters, the URLs for the deployed canisters, and details about token minting and burning processes.

### Frontend Details
The Frontend is a hybrid web application developed in React and hosted on Amazon S3 with CloudFront for distribution.

##### Hosted on
```git
  git@github.com:mettal-stable/mettal-dashboard.git
```

### High Level Mettal Token Application Architecture
![High Level Mettal Token Architecture](https://s3.us-east-1.amazonaws.com/dash.mettal.mx/architecture-diagram-icp.jpg "High Level Mettal Token Architecture")

---

## Deployment Steps

1. Clone Repository from:
```
git@github.com:mettal-stable/mettal-icp-canisters.git
```

2. Navigate to the `mettal-icp-canisters` directory:
```bash
cd mettal-icp-canisters
```

3. Start the Internet Computer framework in the background:

```bash
dfx start --background
```

4. Deploy the canisters using the provided script:
```bash
./scripts/deploy.sh
```

### Deployment Output
Upon successful deployment, the following canisters will be available:

Backend Canisters via Candid Interface:

- icrc1_index_canister:
- http://127.0.0.1:8080/?canisterId=bnz7o-iuaaa-aaaaa-qaaaa-cai&id=bd3sg-teaaa-aaaaa-qaaba-cai

- internet_identity:
- http://127.0.0.1:8080/?canisterId=bnz7o-iuaaa-aaaaa-qaaaa-cai&id=rdmx6-jaaaa-aaaaa-aaadq-cai

- mettal_token_ledger:
- http://127.0.0.1:8080/?canisterId=bnz7o-iuaaa-aaaaa-qaaaa-cai&id=br5f7-7uaaa-aaaaa-qaaca-cai

- mettal_token_transfer: (Minter Canister)
- http://127.0.0.1:8080/?canisterId=bnz7o-iuaaa-aaaaa-qaaaa-cai&id=be2us-64aaa-aaaaa-qaabq-cai


----- 

## Token Management

### How to Mint Tokens
- Token minting is restricted to the Minter Canister.
- The Owner of the Minter Canister, authenticated via a .pem mechanism through the Web2 backend, is the sole entity authorized to generate new tokens for principals.

### How to Burn Tokens
- 	Users can sell their tokens through the Mettal Dashboard. The process is as follows:
- 	Users, logged in using Internet Identity, can approve the Minter Owner to transfer tokens to the Minter Canister. This is done using the icrc2_approve method on the ICRC Ledger.
- 	The Minter Owner calls the Minter Canister to transfer the approved token amount from the user's principal to the canister using the icrc2_transfer_from method.


