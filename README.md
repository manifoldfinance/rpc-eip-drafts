# Draft Specifications for EIP and ERC's

## EIP Proposal for new Transaction Type and corresponding RPC

## Draft EIPS

### eth_getTransactionConfirmations

  The purpose of this method is to return the number of transactions an account has broadcasted or sent.

## Well Defined EIPs

Below EIPs are considered a **requeriment** for us:

- [EIP-2718 | Transaction Envelopes](https://eips.ethereum.org/EIPS/eip-2718)

  **Abstract**: `TransactionType || TransactionPayload` is a valid transaction and `TransactionType || ReceiptPayload` is a valid transaction receipt where `TransactionType` identifies the format of the transaction and `*Payload` is the transaction/receipt contents, which are defined in future EIPs.

- [EIP-2930 | Optional access lists](https://eips.ethereum.org/EIPS/eip-2930)

  **Abstract**: We introduce a new [EIP-2718](./reference/EIPS/eip-2718.md) transaction type, with the format `0x01 || rlp([chainId, nonce, gasPrice, gasLimit, to, value, data, accessList, signatureYParity, signatureR, signatureS])`.
  The `accessList` specifies a list of addresses and storage keys; these addresses and storage keys are added into the `accessed_addresses` and `accessed_storage_keys` global sets (introduced in [EIP-2929](./reference/EIPS/eip-2929.md)). A gas cost is charged, though at a discount relative to the cost of accessing outside the list.

- [EIP-3584 | Block Access Lists](https://eips.ethereum.org/EIPS/eip-3584)

  **Abstract**: A proposal to build a block's `access_list` and include its fingerprint `AccessListRoot` in the block header.

### Complementary EIPs

Below EIPs are considered **complimentary** we don't depend on but can serve us as inspiration:

- [EIP 2976 | Typed Transactions over Gossip](https://eips.ethereum.org/EIPS/eip-2976)

  **Abstract**: [Typed Transactions](./reference/EIPS/eip-2976.md) can be sent over devp2p as `TransactionType || TransactionPayload`.
  The exact contents of the `TransactionPayload` are defined by the `TransactionType` in future EIPs, and clients may start supporting their gossip without incrementing the devp2p version.
  If a client receives a `TransactionType` that it doesn't recognize, it **SHOULD** disconnect from the peer who sent it.
  Clients **MUST NOT** send new transaction types before they believe the fork block is reached.

## EIP Political Process

```mermaid
stateDiagram-v2
  direction LR
  [*] --> Draft
  Draft --> Review
  Review --> Living
  Review --> Implementation
  Implementation --> Final
  Final --> [*]
  Final --> Moribund

  Draft --> Withdrawn
  Review --> Withdrawn
  Implementation --> Withdrawn
  Implementation --> Deferred
  Withdrawn --> [*]
```

