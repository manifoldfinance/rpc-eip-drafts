# Draft RPC Proposals

> RPC Methods for various proposed/draft EIPs

## Abstract

A specification for the new Ethereum JSON-RPC Methods

## Overview

Returns the transaction object for a given sender's address and nonce, if any. This method provides a way for users to check which transaction is using a specific nonce for their address. It can be particularly useful in scenarios where users want to understand the status of a particular transaction or if they suspect that a nonce might have been used maliciously.

## Motivation

> Consider this use case. We journal everything we do. If the system dies we recover the state from that journal and move on. You need to re sync your local state with the chain first. That may mean a tx having been replaced. You can get the new tx, you can only try to fetch the old one and you receive a null. -- _Patricio Palladino_

If a user accidentally uses the same account outside of your system you want to detect it, and without this method it is exceeding difficult.

## List of RPC Specifications

[eth_getTransactionBySenderAndNonce](./eth_getTransactionBySenderAndNonce.md)  
[eth_getLogs+timestamp](./eth_getLogs+timestamp.md)

-   https://ethereum-magicians.org/t/proposal-for-adding-blocktimestamp-to-logs-object-returned-by-eth-getlogs-and-related-requests/11183

## Contributors

Patricio Palladino  
Sam Bacha  
Wighawag

## License

UPL-1.0 / CC-1.0
