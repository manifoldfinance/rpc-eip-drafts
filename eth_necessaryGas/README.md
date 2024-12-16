---
eip: TBD
title: Precise Gas Estimation with eth_necessaryGas
description: A new RPC method that returns the minimum required gas for transaction execution
author: @wjmelements <https://github.com/wjmelements>
discussions-to: https://github.com/ethereum/go-ethereum/pull/29727
status: Draft
type: Standards Track
category: Interface
created: 2024-12-09
requires: 1474, 2930
---

## Abstract

This EIP introduces a new JSON-RPC method `eth_necessaryGas` that returns the minimum gas limit required for a transaction to execute successfully. Unlike `eth_estimateGas`, this method guarantees the returned value is the lowest possible gas limit that ensures transaction success, providing more precise gas estimation.

## Motivation

The existing `eth_estimateGas` method often returns conservative estimates that may be significantly higher than necessary. This leads to:
1. Users overpaying for gas
2. Transactions consuming more of the block gas limit than needed
3. Difficulty in optimizing gas usage in smart contracts

This new method addresses these issues by returning the exact minimum gas required for successful execution.

## Specification

### JSON-RPC Method Definition

#### eth_necessaryGas

Returns the minimum gas limit required for a transaction to execute successfully.

##### Parameters

1. `Object` - The transaction call object
    - `from`: `DATA`, 20 Bytes - (optional) The address the transaction is sent from
    - `to`: `DATA`, 20 Bytes - The address the transaction is directed to
    - `gas`: `QUANTITY` - (optional) Integer of the maximum gas limit provided for the estimation. Must be greater than minimum transaction gas (21000). Server will cap returned value to this amount if specified.
    - `gasPrice`: `QUANTITY` - (optional) Integer of the gas price used for each paid gas
    - `maxFeePerGas`: `QUANTITY` - (optional) Maximum total fee per gas the sender is willing to pay (includes the priority fee)
    - `maxPriorityFeePerGas`: `QUANTITY` - (optional) Maximum priority fee per gas the sender is willing to pay
    - `value`: `QUANTITY` - (optional) Integer of the value sent with this transaction
    - `data`: `DATA` - (optional) Hash of the method signature and encoded parameters
    - `nonce`: `QUANTITY` - (optional) Integer of a nonce

2. `QUANTITY|TAG|OBJECT` - (optional) Integer block number, or the string "latest", "earliest" or "pending", or block hash object as defined in EIP-1898

##### Returns

`QUANTITY` - The minimum gas limit required for successful transaction execution.

##### Example

Request:
```json
{
  "id": 1,
  "jsonrpc": "2.0",
  "method": "eth_necessaryGas",
  "params": [
    {
      "from": "0x8D97689C9818892B700e27F316cc3E41e17fBeb9",
      "to": "0x3535353535353535353535353535353535353535",
      "data": "0x6060604052341561000f57600080fd5b60"
    },
    "latest"
  ]
}
```

Response:
```json
{
  "id": 1,
  "jsonrpc": "2.0",
  "result": "0x5208" // 21000 in hex
}
```

##### Error Codes

- `-32000`: Invalid input or execution error
- `-32001`: Transaction would revert
- `-32002`: Block not found
- `-32003`: Gas estimation exceeds configured cap

### Implementation Requirements

1. The method MUST return the exact minimum gas required for successful execution
2. The method MUST return an error if the transaction would revert
3. The method MUST cap the returned value by:
   - The `gas` parameter in the transaction object (if specified and non-zero)
   - The node's configured RPC gas cap (if non-zero)
4. The method MUST NOT include blob gas calculations in the returned value
5. The method MUST support all block specifiers as defined in EIP-1898
6. The method MUST execute the transaction in a temporary state to determine gas usage

### Security Considerations

1. Nodes should implement appropriate rate limiting to prevent DoS attacks
2. Gas estimation may be computationally intensive for complex contracts
3. The returned value should be treated as valid only for the specified block
4. Users should still include a safety margin when setting gas limits

### Backwards Compatibility

This EIP introduces a new method and does not modify existing functionality. No backwards compatibility issues are present.

## Rationale

The name `eth_necessaryGas` was chosen to differentiate it from `eth_estimateGas` and to emphasize its purpose of returning the exact minimum required gas. The method is designed to be compatible with existing transaction formats and block specifiers.

The decision to exclude blob gas calculations aligns with the separation of concerns principle and allows for cleaner integration with EIP-4844.

## Reference Implementation

```go
// NecessaryGas returns the lowest gas limit that allows the transaction to run
// successfully at block `blockNrOrHash`, or the latest block if `blockNrOrHash` is unspecified.
func (s *PublicBlockChainAPI) NecessaryGas(ctx context.Context, args TransactionArgs, blockNrOrHash *rpc.BlockNumberOrHash) (hexutil.Uint64, error) {
    bNrOrHash := rpc.BlockNumberOrHashWithNumber(rpc.LatestBlockNumber)
    if blockNrOrHash != nil {
        bNrOrHash = *blockNrOrHash
    }
    
    state, header, err := s.b.StateAndHeaderByNumberOrHash(ctx, bNrOrHash)
    if err != nil {
        return 0, err
    }
    
    // Cap gas limit if requested
    if args.Gas != nil && uint64(*args.Gas) != 0 {
        if uint64(*args.Gas) < params.TxGas {
            return 0, fmt.Errorf("gas limit cannot be lower than %d", params.TxGas)
        }
    }
    
    // Execute transaction with binary search for exact gas limit
    result, err := s.findExactGasLimit(ctx, args, state, header)
    if err != nil {
        return 0, err
    }
    
    return hexutil.Uint64(result), nil
}
```

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
