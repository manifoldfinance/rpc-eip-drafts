---
eip: XXXX
title:  Introduction of `trace_gasLimit` for Enhanced Gas Measurement
author:
discussions-to:
status: unsubmitted working draft
type: Standards Track
category: Core
created:
---

# Introduction of `trace_gasLimit` for Enhanced Gas Measurement

> [!IMPORTANT]
> Work in Progress

## **Abstract**

This EIP proposes the introduction of a new measurement, `trace_gasLimit`, to the Ethereum Virtual Machine (EVM). The `trace_gasLimit` aims to provide a more nuanced understanding of gas usage, particularly in transactions involving complex interactions and nested calls. It represents the difference between a transaction's gas limit and a calculated *trace limit*. This proposal seeks to improve transaction efficiency, enhance gas management, and provide deeper insights into gas consumption patterns.

## **Motivation**

The current gas measurement mechanisms in Ethereum do not account for the intricacies of transaction execution, especially in scenarios involving nested calls and the execution of multiple opcodes. The introduction of `trace_gasLimit` addresses this gap by offering a detailed measure that considers the gas costs associated with access lists, calldata, and base transaction costs. This measure facilitates better gas management and optimization strategies for developers, ultimately leading to more efficient contract execution and reduced transaction costs.

## **Specification**

1. **Definition of `trace_gasLimit`:** The `trace_gasLimit` is defined as the difference between a transaction's `gaslimit` and its *trace limit*. The *trace limit* is the sum of the access list gas cost, the calldata gas cost, and the base transaction cost (21000 gas units, as defined by Wood, G., et al. (2014) in the Ethereum Yellow Paper).

2. **Calculation Method:** 
   > The *trace limit* is calculated as follows:
   - `trace_limit` = transaction `gaslimit` - (accessList `gascost` + calldata `gascost` + 21000)
   - Therefore, `trace_gasLimit` = transaction `gaslimit` - `trace_limit`

4. **Application in Transaction Processing:**
   - For each transaction, the EVM calculates the `trace_gasLimit` to determine the available gas after accounting for the costs associated with access lists, calldata, and the base transaction fee.
   - The `trace_gasLimit` is used in the last topcall of a transaction to guide gas usage and optimization, particularly in complex transactions involving nested calls.

5. **Debugging and Gas Usage Analysis:**
   - The `debug.traceTransaction('txhash')` function is enhanced to report `trace_gasLimit` utilization, providing a detailed view of gas consumption at each step of transaction execution.
   - This enhancement aids in debugging and optimization by highlighting potential inefficiencies in gas usage.

#### Reference

`trace_gasLimit`: The difference between transaction `gaslimit` and *trace limit*. The *trace limit* is calculated by the transaction gas limit minus accessList `gascost`, `calldata` `gascost` and `21000` (transaction base cost[^1]). 

Last `subcall`. Use the last `topcall` to calculate *I* for `calltrace` the `gasUsed` in the `calltrace` includes its `subcall` `gasUsed`.
`debug.traceTransaction('txhash')`. The result is large (enough to cause Out Of Memory issues), it reports every `OP_CODE` execution. This though gives us a running total of refund `gas` at each point.

## **Rationale**

The rationale behind introducing `trace_gasLimit` is to offer a more granular view of gas consumption in Ethereum transactions. By accounting for the specific costs of access lists and calldata, developers can gain insights into the internal dynamics of transaction execution. This proposal aims to make gas usage more transparent and optimize transaction processing by providing a tool for detailed gas analysis and management.

## **Backwards Compatibility**

This EIP is backward compatible as it introduces a new measurement that does not interfere with existing mechanisms. However, clients and tools that implement this EIP will need to update their gas calculation and reporting functionalities to accommodate `trace_gasLimit`.

## **Security Considerations**

The introduction of `trace_gasLimit` does not pose direct security risks but requires careful implementation to ensure accurate gas calculations. Incorrect implementation could lead to misreporting of gas usage, affecting transaction processing and optimization efforts.

## **References**

[^1]:  Wood, G., & others (2014). Ethereum: A secure decentralised generalised transaction ledger_. Ethereum project yellow paper, _151_(2014), 1–32.

**Copyright**

2024 (C) The Authors
