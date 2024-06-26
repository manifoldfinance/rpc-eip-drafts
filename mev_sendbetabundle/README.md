# EIP-XXXX: MEV Send Beta Bundle Method

## Simple Summary
Introduces a custom JSON-RPC method `mev_sendBetaBundle` for submitting a set of transactions as a bundle to be included in a specific block on the Ethereum blockchain, targeting scenarios where transactions are not priority-sensitive.

## Abstract
This EIP proposes a new JSON-RPC method that allows the submission of a bundle of transactions to be included in a specific block. This method is designed for transactions that do not require priority ordering within the block. The method ensures that transactions originating from the sender have a corresponding call option for the specified slot. Transactions exceeding the block's remaining gas limit are dropped in the order listed within the bundle, allowing partial fulfillment of the bundle.

## Motivation
Miner Extractable Value (MEV) strategies often require the submission of transaction bundles that are executed together within the same block to exploit arbitrage opportunities, perform liquidations, or protect against front-running. The existing JSON-RPC methods do not support the submission of transaction bundles with specific block targeting and handling for non-priority sensitive transactions. This EIP aims to fill this gap, providing developers and MEV searchers with a tool to more effectively manage their transactions.

## Specification

> [!NOTE]
> See the [OpenAPI Specification document for cannonical API](https://github.com/manifoldfinance/rpc-eip-drafts/blob/master/mev_sendbetabundle/openapi.yaml)

### Method Name
`mev_sendBetaBundle`

### Parameters
1. `txs` - Array of raw transactions (as hex strings) to be included in the bundle. (Required)
2. `slot` - The block number (as a string) at which the bundle should be included. (Required)

### Returns
- `jsonrpc`: The JSON-RPC version (i,e "2.0").
- `method`: The method name (`mev_sendBetaBundle`).
- `params`: An array containing a single object with two fields: `txs` (an array of raw transaction data) and `slot` (the target block number as a string).
- `id`: A unique identifier for the request.

### Errors
- If the transaction originator does not have a corresponding call option for the specified slot, the method will fail.
- Transactions that would cause the block's gas limit to be exceeded are dropped in the order they appear in the bundle.

### Example

#### Request

```jsonc
{
  "jsonrpc": "2.0",
  "method": "mev_sendBetaBundle",
  "params": [
    {
      "txs": ["0x..."],
      "slot": "1001"
    }
  ],
  "id": 8
}
```

#### Response

```jsonc
{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "mev_sendBetaBundle",
    "result": "0x79e5cba7876f532218ac35a357209800be2362dd2e3f1e6dc5974698f0d7cee4"
}
```


## Rationale
The `mev_sendBetaBundle` method is designed to accommodate the specific needs of MEV strategies that do not require transactions to be executed in a priority order within a block. By allowing transactions to be bundled and specifying the block in which they should be included, this method provides a more flexible and efficient way to manage MEV-related transactions. The decision to drop transactions exceeding the block's gas limit in the order they are listed allows for partial fulfillment of the bundle, ensuring that the most critical transactions can be prioritized by the sender.

## Security Considerations

- This method requires careful management of the block's gas limit to prevent denial of service attacks by submitting large bundles that could monopolize block space.
- Implementers should ensure that only authorized users have the ability to submit transaction bundles to prevent spam and potential manipulation of block contents.

## Test Cases
- Submission of a valid transaction bundle for a future block.
- Handling of a bundle when the block's gas limit is exceeded.
- Rejection of a bundle when the sender does not have a corresponding call option for the specified slot.

## Implementation
This EIP requires changes to Ethereum client software to support the new JSON-RPC method. Implementations should follow the specifications outlined above to ensure compatibility across different clients.
