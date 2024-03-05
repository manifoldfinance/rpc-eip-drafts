---
EIP: XXXX
Title: Add `eth_getinclusionstats` RPC Method
Author: [Author Name] <[email address]>
Type: Standards Track
Category: Interface
Status: Draft
Created: [Date]
Requires: [EIPs (if any)]
---

**EIP-XXXX: `eth_getinclusionstats` RPC Method**

**Preamble**

TODO

**Abstract**

This EIP proposes the addition of a new RPC method, `eth_getinclusionstats`, to the Ethereum client interface. This method aims to provide analytics on the inclusion of transactions within blocks, offering insights into transaction finality, inclusion rates, and potentially congestion patterns on the network.

**Motivation**

Understanding transaction inclusion dynamics is crucial for both users and developers interacting with the Ethereum blockchain. The `eth_getinclusionstats` method will offer valuable data regarding how quickly transactions are being included in blocks, the success rate of these inclusions, and general network congestion. This can aid in transaction fee estimation, network analysis, and enhancing user experience by providing more transparent transaction information.

**Specification**

-   **Method Name**: `eth_getinclusionstats`

-   **Parameters**:

    1. `TRANSACTION_HASH`: The hash of the transaction for which inclusion statistics are being requested.
    2. `BLOCK_PARAMETER`: An optional parameter specifying the block (by number, hash, or the string "latest") up to which the search should be conducted. If omitted, the search includes the latest block.

-   **Returns**: An object containing:

    -   `included`: A boolean indicating whether the transaction was included in a block (`true`) or not (`false`).
    -   `blockHash`: The hash of the block in which the transaction was included. `null` if the transaction has not been included in any block.
    -   `blockNumber`: The number of the block in which the transaction was included. `null` if the transaction has not been included in any block.
    -   `transactionIndex`: The index position of the transaction in the block. `null` if the transaction has not been included in any block.
    -   Additional fields may be included to provide further analytics, such as average inclusion time, network congestion metrics, etc.

-   **Example**:

    ```
    // Request
    {
      "jsonrpc": "2.0",
      "method": "eth_getinclusionstats",
      "params": ["0x...transaction hash...", "latest"],
      "id": 1
    }

    // Response
    {
      "jsonrpc": "2.0",
      "id": 1,
      "result": {
        "included": true,
        "blockHash": "0x...block hash...",
        "blockNumber": "0x...block number...",
        "transactionIndex": "0x15"
        // Additional fields as necessary
      }
    }
    ```

**Rationale**

The choice of parameters and the return structure is designed to provide a straightforward yet comprehensive overview of a transaction's inclusion status. This method extends the Ethereum JSON RPC interface in a manner consistent with existing methods, such as `eth_getTransactionReceipt`, while focusing on analytics that are not currently available through standard methods.

**Security Considerations**

Implementations should ensure that this method does not expose Ethereum nodes to additional vectors for denial-of-service attacks. Care must be taken to manage the computational load of generating inclusion statistics, especially when querying data over large numbers of blocks.

**Backwards Compatibility**

This EIP is fully backwards compatible as it introduces a new method without altering any existing functionality.

**Test Cases**

Test cases for an implementation are essential for ensuring the method behaves as expected across different scenarios. These should cover, at a minimum:

-   A transaction included in a block.
-   A transaction not yet included in any block.
-   Querying with and without the `BLOCK_PARAMETER`.

**Implementation**

[Note: The implementation details would typically be provided here, potentially with links to a GitHub repository containing the code.]

**References**

-   Existing Ethereum JSON RPC documentation.
-   Related EIPs and Ethereum GitHub discussions.

---

Please adapt the specifics based on the actual content of the `eth_getinclusionstats` method as described on the page you have. This template should give you a solid foundation to draft a comprehensive EIP.
