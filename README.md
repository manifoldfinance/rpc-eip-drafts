# `eth_getTransactionBySenderAndNonce`

> RPC Method for verifying Onnichain transaction confirmations and recoverying faster for local chain state sync use cases.

## Abstract

A specification for the new Ethereum JSON-RPC Method `eth_getTransactionBySenderAndNonce`:

## Overview

Returns the transaction object for a given sender's address and nonce, if any. This method provides a way for users to check which transaction is using a specific nonce for their address. It can be particularly useful in scenarios where users want to understand the status of a particular transaction or if they suspect that a nonce might have been used maliciously.

## Motivation

> Consider this use case. We journal everything we do. If the system dies we recover the state from that journal and move on. You need to re sync your local state with the chain first. That may mean a tx having been replaced. You can get the new tx, you can only try to fetch the old one and you receive a null. -- *Patricio Palladino*

If a user accidentally uses the same account outside of your system you want to detect it, and without this method it is exceeding difficult. 


## Specification

[eth_getTransactionBySenderAndNonce](./eth_getTransactionBySenderAndNonce.md)

## Contributors

Patricio Palladino    
Sam Bacha     

## License 

UPL-1.0 / CC-1.0


