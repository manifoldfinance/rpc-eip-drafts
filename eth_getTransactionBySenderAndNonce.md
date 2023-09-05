---
title: Specification for eth_getTransactionBySenderAndNonce RPC Method
description:
version:
author:
---

## `eth_getTransactionBySenderAndNonce`

Returns the transaction object for a given sender's address and nonce, if any.

### Parameters

1. `address`: `DATA`, 20 bytes - Address of the sender.
2. `nonce`: `QUANTITY` - The nonce to be queried.

### Returns

`Object` - A transaction object, or `null` if no transaction matches the given sender and nonce. The transaction object has the following fields:

-   `hash`: `DATA`, 32 bytes - Hash of the transaction.
-   `nonce`: `QUANTITY` - The number of transactions made by the sender prior to this one.
-   `blockHash`: `DATA`, 32 bytes - Hash of the block where this transaction was in. `null` when its pending.
-   `blockNumber`: `QUANTITY` - Block number where this transaction was in. `null` when its pending.
-   `transactionIndex`: `QUANTITY` - Integer of the transactions index position in the block. `null` when its pending.
-   `from`: `DATA`, 20 bytes - Address of the sender.
-   `to`: `DATA`, 20 bytes - Address of the receiver. `null` when its a contract creation transaction.
-   `value`: `QUANTITY` - Value transferred in Wei.
-   `gasPrice`: `QUANTITY` - Gas price provided by the sender in Wei.
-   `gas`: `QUANTITY` - Gas provided by the sender.
-   `input`: `DATA` - The data sent along with the transaction.

### Example

#### Request

```json
{
	"id": 1,
	"jsonrpc": "2.0",
	"method": "eth_getTransactionBySenderAndNonce",
	"params": ["0x407d73d8a49eeb85d32cf465507dd71d507100c1", "0x1"]
}
```

#### Response

```json
{
	"id": 1,
	"jsonrpc": "2.0",
	"result": {
		"hash": "0x9fc76417374aa880d4449a1f7f31ec597f00b1f6f3dd2d66f4c9c6c445836d8b",
		"nonce": "0x1",
		"blockHash": "0xef95f2f1ed3ca60b048b4bf67cde2195961e0bba6f70bcbea9a2c4e133e34b46",
		"blockNumber": "0x6fd9e2a26ab",
		"transactionIndex": "0x1",
		"from": "0x407d73d8a49eeb85d32cf465507dd71d507100c1",
		"to": "0x85h43d8a49eeb85d32cf465507dd71d507100c2",
		"value": "0x7f110",
		"gasPrice": "0x09184e72a000",
		"gas": "0x2710",
		"input": "0x68656c6c6f21"
	}
}
```

---

This method provides a way for users to check which transaction is using a specific nonce for their address. It can be particularly useful in scenarios where users want to understand the status of a particular transaction or if they suspect that a nonce might have been used maliciously.
