---
eip: TBD
title: Effective Gas Tip RPC Method
description: A new RPC method for calculating effective miner tips considering base fee
author: [Author Name] (@github)
discussions-to: TBD
status: Draft
type: Standards Track
category: Interface
created: 2024-12-16
requires: 1559
---

## Abstract

This EIP introduces a new JSON-RPC method `eth_effectiveGasTip` that calculates the effective miner tip (priority fee) for a transaction given the current base fee. This method helps users and applications understand the actual tip that would be provided to validators under current network conditions.

## Motivation

Since the introduction of EIP-1559, calculating effective miner tips has become more complex due to the interaction between `maxFeePerGas`, `maxPriorityFeePerGas`, and the current base fee. Users and applications need a standardized way to:

1. Calculate the actual tip that validators would receive
2. Determine if their gas fee parameters would result in valid transactions
3. Handle cases where gas parameters might result in negative effective tips

## Specification

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119.

### JSON-RPC Method Definition

#### eth_effectiveGasTip

Returns the effective miner tip (gas tip cap) for a given transaction considering the current base fee.

##### Parameters

1. `Object` - The transaction parameters
    - `maxFeePerGas`: `QUANTITY` - REQUIRED. The maximum fee per gas the sender is willing to pay
    - `maxPriorityFeePerGas`: `QUANTITY` - REQUIRED. The maximum priority fee per gas
2. `QUANTITY` - REQUIRED. The current base fee per gas

##### Returns

`Object` - The result object
- `effectiveTip`: `QUANTITY` - The calculated effective tip
- `error`: `STRING` - OPTIONAL. Present only if the effective tip would be negative, contains "ErrGasFeeCapTooLow"

##### Implementation Requirements

Clients implementing this method MUST:

1. Calculate the effective tip using the formula:
   ```
   effectiveTip = min(maxPriorityFeePerGas, maxFeePerGas - baseFee)
   ```

2. Handle negative effective tips by:
   - Including the negative value in the response
   - Adding an error field with "ErrGasFeeCapTooLow"
   - Continuing to process the request rather than returning an error response

3. Validate all input parameters:
   - Ensure both gas fee parameters are present and non-null
   - Verify all values are valid hexadecimal quantities
   - Check that values don't exceed implementation-specific limits

4. Return consistent error responses for invalid inputs:
   - Missing required parameters
   - Invalid hexadecimal values
   - Values exceeding implementation limits

##### Example

Request:
```json
{
  "id": 1,
  "jsonrpc": "2.0",
  "method": "eth_effectiveGasTip",
  "params": [
    {
      "maxFeePerGas": "0x2540be400",
      "maxPriorityFeePerGas": "0x3b9aca00"
    },
    "0x2540be400"
  ]
}
```

Response (successful case):
```json
{
  "id": 1,
  "jsonrpc": "2.0",
  "result": {
    "effectiveTip": "0x3b9aca00"
  }
}
```

Response (negative tip case):
```json
{
  "id": 1,
  "jsonrpc": "2.0",
  "result": {
    "effectiveTip": "-0x3b9aca00",
    "error": "ErrGasFeeCapTooLow"
  }
}
```

### Security Considerations

1. Input Validation
   - Implementations MUST validate all numeric inputs to prevent integer overflow
   - Implementations SHOULD set reasonable upper bounds for gas parameters

2. Resource Usage
   - While this is a read-only method, implementations SHOULD implement rate limiting
   - Implementations MAY cache results briefly for identical inputs

3. Error Handling
   - Negative tips MUST be reported clearly to prevent confusion
   - Implementation SHOULD provide clear error messages for all failure cases

### Backwards Compatibility

This EIP introduces a new method and does not modify existing behavior. No backwards compatibility issues are present.

## Rationale

The design choices in this specification are motivated by several factors:

1. The decision to return both negative values and errors provides maximum information to clients while maintaining protocol semantics.

2. The method name `eth_effectiveGasTip` was chosen to clearly indicate its purpose and relationship to EIP-1559 gas parameters.

3. The parameter structure matches existing Ethereum RPC conventions while providing all necessary information for the calculation.

4. The requirement to continue processing negative tips (rather than returning an error) allows applications to handle these cases gracefully.

## Reference Implementation

```go
func (s *PublicBlockChainAPI) EffectiveGasTip(args TransactionArgs, baseFee *big.Int) (*EffectiveGasTipResult, error) {
    if args.MaxFeePerGas == nil || args.MaxPriorityFeePerGas == nil {
        return nil, errors.New("missing required gas fee parameters")
    }
    
    // Calculate effective tip
    maxFee := args.MaxFeePerGas.ToInt()
    maxPriority := args.MaxPriorityFeePerGas.ToInt()
    
    // Subtract base fee from max fee
    remainingFee := new(big.Int).Sub(maxFee, baseFee)
    
    // Take minimum of remaining fee and max priority fee
    effectiveTip := math.BigMin(remainingFee, maxPriority)
    
    result := &EffectiveGasTipResult{
        EffectiveTip: (*hexutil.Big)(effectiveTip),
    }
    
    // Check for negative tip
    if effectiveTip.Sign() < 0 {
        result.Error = "ErrGasFeeCapTooLow"
    }
    
    return result, nil
}
```

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
