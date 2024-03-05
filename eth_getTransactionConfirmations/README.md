---
Title: eth_getTransactionConfirmations JSON-RPC Method Specification for Ethereum Clients
Author: Sam Bacha, {{ contributors }}
Date: { { rfc.3339=seconds } }
Status: Draft
---

## Overview

This document proposes a new JSON-RPC method for Ethereum clients named "eth_getTransactionConfirmations". The purpose of this method is to return the number of transactions an account has broadcasted or sent.

## Terminology

-   JSON-RPC: A remote procedure call (RPC) protocol encoded in JSON.
-   Ethereum: An open-source, blockchain-based platform featuring smart contract functionality.
-   Transaction: A signed data package that stores a message to be sent from an externally owned account.

## Specification

### Method Name

eth_getTransactionConfirmations

### Parameters

1. `address`: (20 Bytes) - Address of the account.
2. `blockTag`: (String) - The string "latest" OR "earliest" OR "pending". Describes the state of the blockchain to consider.
3. `blockNumber`: (QUANTITY) - Integer of a block number.

### Returns

`QUANTITY` - The number of transactions sent from the given address.

#### Example

##### Request

```json
{
	"id": 1,
	"jsonrpc": "2.0",
	"method": "eth_getTransactionConfirmations",
	"params": ["0x742d35Cc6634C0532925a3b844Bc454e4438f44e", "latest", "0x1b4"]
}
```

##### Response

```json
{
	"id": 1,
	"jsonrpc": "2.0",
	"result": "0x41"
}
```

## Rationale

The addition of the "eth_getTransactionConfirmations" method will allow DApps and other Ethereum-based applications to easily retrieve the number of transactions an account has sent. This can be useful for tracking and verifying the activity of an account over a specific period or up to the latest block.

### Backwards Compatibility

This change is fully backward compatible as it introduces a new method and does not alter any existing methods or behaviors.

## Implementation

Clients wishing to support this method will need to index transactions by sender address and be able to query this index to count the number of transactions sent by a given address.

## Security Considerations

Implementers should be aware of potential large datasets when querying for accounts with a high number of transactions. Proper measures should be taken to handle such cases efficiently.

## Copyright

Copyright 2023 Manifold Finance, Inc.
