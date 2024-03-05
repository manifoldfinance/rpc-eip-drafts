---
EIP: XXXX
Title: Add `eth_getbundlestats` RPC Method for Bundle Analytics
Author: [Author's Name] <[email|website]>
Type: Standards Track
Category: Interface
Status: Draft
Created: [Creation Date]
---

**EIP-XXXX: `eth_getbundlestats` RPC Method**

**Preamble**

**Abstract**

This EIP proposes the introduction of a new JSON-RPC method, `eth_getbundlestats`, designed to provide statistical data on transaction bundles within the Ethereum network. This method aims to enhance network transparency by offering insights into bundle composition, success rates, and their impact on network congestion and gas prices.

**Motivation**

With the increasing complexity of Ethereum transactions and the use of transaction bundles by miners and traders, there's a growing need for better analytics around these bundles. Understanding the dynamics of bundle inclusion, their sizes, gas prices, and how they affect the Ethereum network can provide valuable insights for developers, traders, and researchers. The `eth_getbundlestats` method will fill this gap by offering detailed analytics on transaction bundles.

**Specification**

-   **Method Name**: `eth_getbundlestats`

-   **Parameters**:

    1. `BLOCK_NUMBER`: The specific block number to retrieve bundle statistics for. This parameter is REQUIRED.
    2. `BUNDLE_IDENTIFIER`: An optional identifier for specific bundles to filter the statistics. If omitted, statistics for all bundles in the specified block are returned.

-   **Returns**: An object containing statistical data about the transaction bundles within the specified block. The object includes:

    -   `totalBundles`: The total number of bundles included in the block.
    -   `averageBundleSize`: The average number of transactions per bundle.
    -   `averageGasPrice`: The average gas price of transactions within the bundles.
    -   `successRate`: The percentage of bundles successfully included in the block without reverts.
    -   `details`: An array of objects, each representing a bundle, including its identifier, size, gas price, and success status.

-   **Example**:

    ```
    // Request
    {
      "jsonrpc": "2.0",
      "method": "eth_getbundlestats",
      "params": [1234567],
      "id": 1
    }

    // Response
    {
      "jsonrpc": "2.0",
      "id": 1,
      "result": {
        "totalBundles": 5,
        "averageBundleSize": 10,
        "averageGasPrice": "100000000000",
        "successRate": 80,
        "details": [
          {
            "bundleIdentifier": "0x...",
            "size": 12,
            "gasPrice": "120000000000",
            "success": true
          },
          // Additional bundles...
        ]
      }
    }
    ```

**Rationale**

The choice of parameters allows users to specify the exact block for which they seek bundle statistics, offering flexibility in analysis. Including an optional bundle identifier parameter enables focused studies on particular bundles of interest. The structure of the return object is designed to provide a comprehensive overview of bundle activity within a block, catering to various analytical needs.

**Security Considerations**

Implementations should ensure that the method does not expose nodes to additional security vulnerabilities, particularly in relation to privacy or DoS attacks. Care must be taken to prevent excessive resource consumption when calculating statistics, especially for blocks with a high number of transactions and bundles.

**Backwards Compatibility**

This EIP is fully backwards compatible as it introduces a new method without modifying any existing functionality.

**Test Cases**

Test cases should cover various scenarios, including blocks with:

-   A high number of bundles
-   No bundles
-   Blocks during periods of high and low network congestion
-   Requests specifying a bundle identifier and requests without it

**Implementation**

[Note: Implementation details or a link to the implementation code would be provided here.]

**References**

-   Existing JSON-RPC specification documents.
-   Related EIPs and discussions on Ethereum transaction bundles and analytics.

---

This example EIP for the `eth_getbundlestats` method is hypothetical and based on assumed functionality. For a real proposal, you would need to replace placeholders with actual data and ensure the specification accurately reflects the method's implementation and intended use.
