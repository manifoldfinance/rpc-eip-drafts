# `eth_getTransactionBySenderAndNonce`

## Abstract

A specification for the new Ethereum JSON-RPC Method `eth_getTransactionBySenderAndNonce`:

## Overview

Returns the transaction object for a given sender's address and nonce, if any. This method provides a way for users to check which transaction is using a specific nonce for their address. It can be particularly useful in scenarios where users want to understand the status of a particular transaction or if they suspect that a nonce might have been used maliciously.

## Specification

[eth_getTransactionBySenderAndNonce](./eth_getTransactionBySenderAndNonce.md)

## Contributors

Patricio Palladino Sam Bacha
