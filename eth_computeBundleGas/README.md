---
eip: TBD
title: Bundle Gas Computation RPC Method
description: A new RPC method, eth_computeBundleGas,  for calculating adjusted gas prices for transaction bundles
author:
discussions-to: TBD
status: Draft
type: Standards Track
category: Interface
created: 2024-12-16
requires: 1559, 4337
---

## Abstract

This EIP introduces a new JSON-RPC method `eth_computeBundleGas` that calculates the adjusted gas price for a bundle of transactions, taking into account gas usage, original gas prices, and direct coinbase transfers. This method is particularly useful for MEV-aware applications and bundle builders.

## Motivation

Transaction bundles have become increasingly important with the rise of MEV extraction and complex DeFi interactions. Currently, there is no standardized way to:

1. Calculate the effective gas price for a bundle of transactions
2. Account for direct coinbase payments in bundle pricing
3. Determine the total value extraction from a bundle

## Specification

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119.


### eth_computeBundleGas

> [!IMPORTANT]
> JSON-RPC Method Definition    
>

Computes the adjusted gas price for a bundle of transactions, accounting for all gas expenditure and coinbase transfers.

##### Parameters

1. `Array of Object` - The bundle of transactions
    - Each object MUST contain:
        - `hash`: `DATA` - Transaction hash
        - `gasUsed`: `QUANTITY` - Gas used by the transaction
        - `gasPrice`: `QUANTITY` - Original gas price
        - `coinbaseTransfers`: `QUANTITY` - Value transferred to coinbase

##### Returns

`Object` - The bundle gas calculation results
- `adjustedGasPrice`: `QUANTITY` - The computed adjusted gas price for the bundle
- `totalGasUsed`: `QUANTITY` - Total gas consumed by the bundle
- `totalValue`: `QUANTITY` - Total value including gas costs and coinbase transfers
- `perTxMetrics`: `Array of Object` - OPTIONAL. Detailed metrics for each transaction
  - `effectiveGasPrice`: `QUANTITY` - Individual transaction's effective gas price
  - `valueContribution`: `QUANTITY` - Transaction's contribution to total value

##### Implementation Requirements

Clients implementing this method MUST:

1. Calculate bundle metrics using the following formulas:
   ```
   totalGasUsed = sum(tx.gasUsed for tx in bundle)
   totalGasCost = sum(tx.gasUsed * tx.gasPrice for tx in bundle)
   totalCoinbaseTransfers = sum(tx.coinbaseTransfers for tx in bundle)
   adjustedGasPrice = (totalGasCost + totalCoinbaseTransfers) / totalGasUsed
   ```

2. Validate the bundle:
   - Ensure at least one transaction is present
   - Verify all required fields are present for each transaction
   - Check that all numerical values are valid and non-negative

3. Handle edge cases:
   - Return an error if totalGasUsed is zero
   - Handle arithmetic overflow in calculations
   - Properly round results when division is not exact

##### Example

Request:
```json
{
  "id": 1,
  "jsonrpc": "2.0",
  "method": "eth_computeBundleGas",
  "params": [[
    {
      "hash": "0x123...",
      "gasUsed": "0x5208",
      "gasPrice": "0x4a817c800",
      "coinbaseTransfers": "0x0"
    },
    {
      "hash": "0x456...",
      "gasUsed": "0x7530",
      "gasPrice": "0x4a817c800",
      "coinbaseTransfers": "0x2386f26fc10000"
    }
  ]]
}
```

Response:
```json
{
  "id": 1,
  "jsonrpc": "2.0",
  "result": {
    "adjustedGasPrice": "0x4d853c800",
    "totalGasUsed": "0xc738",
    "totalValue": "0x2386f26fc10000",
    "perTxMetrics": [
      {
        "effectiveGasPrice": "0x4a817c800",
        "valueContribution": "0x1234"
      },
      {
        "effectiveGasPrice": "0x4f817c800",
        "valueContribution": "0x5678"
      }
    ]
  }
}
```

### Security Considerations

1. Bundle Size Limits
   - Implementations MUST set a maximum bundle size
   - Implementations SHOULD limit total computation time

2. Numerical Handling
   - All arithmetic operations MUST handle overflow conditions
   - Implementations SHOULD use appropriate precision for calculations

3. Resource Protection
   - Methods MUST implement rate limiting
   - Implementations SHOULD cache results for identical bundles briefly

4. Input Validation
   - All transaction parameters MUST be validated
   - Implementations SHOULD check for realistic value ranges

### Backwards Compatibility

This EIP introduces a new method and does not modify existing behavior. No backwards compatibility issues are present.

## Rationale

The design choices in this specification are motivated by several factors:

1. Including per-transaction metrics allows for detailed analysis of bundle composition

2. Separating coinbase transfers from gas costs provides transparency into MEV extraction

3. The comprehensive validation requirements ensure consistent behavior across clients

4. The method name clearly indicates its purpose while following Ethereum naming conventions

## Reference Implementation

```go
func (s *PublicBlockChainAPI) ComputeBundleGas(bundle []BundleTransaction) (*BundleGasResult, error) {
    if len(bundle) == 0 {
        return nil, errors.New("empty bundle")
    }
    
    totalGasUsed := new(big.Int)
    totalGasCost := new(big.Int)
    totalCoinbaseTransfers := new(big.Int)
    perTxMetrics := make([]TxMetrics, len(bundle))
    
    for i, tx := range bundle {
        // Calculate gas cost
        gasCost := new(big.Int).Mul(tx.GasUsed, tx.GasPrice)
        totalGasCost.Add(totalGasCost, gasCost)
        
        // Add gas used
        totalGasUsed.Add(totalGasUsed, tx.GasUsed)
        
        // Add coinbase transfers
        totalCoinbaseTransfers.Add(totalCoinbaseTransfers, tx.CoinbaseTransfers)
        
        // Calculate per-tx metrics
        perTxMetrics[i] = calculateTxMetrics(tx, gasCost)
    }
    
    // Calculate adjusted gas price
    adjustedGasPrice := new(big.Int).Add(totalGasCost, totalCoinbaseTransfers)
    adjustedGasPrice.Div(adjustedGasPrice, totalGasUsed)
    
    return &BundleGasResult{
        AdjustedGasPrice:    (*hexutil.Big)(adjustedGasPrice),
        TotalGasUsed:        (*hexutil.Big)(totalGasUsed),
        TotalValue:          (*hexutil.Big)(totalCoinbaseTransfers),
        PerTxMetrics:        perTxMetrics,
    }, nil
}
```

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
