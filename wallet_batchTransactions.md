# wallet_batchTransactions JSON-RPC method (v1, EOA-compatible)

## TABLE OF CONTENTS

- [Simple summary](#simple-summary)
- [Motivation](#motivation)
- [Specification](#specification)
- [Rationale](#rationale)
- [Backwards compatibility](#backwards-compatibility)
- [General considerations](#general-considerations)
- [Security considerations](#security-considerations)
- [Reference implementation](#reference-implementations)

### SIMPLE SUMMARY
wallet_batchTransactions is an RPC method for bundling multiple transactions into a single transaction (a batch).

### MOTIVATION
**UX**: Instead of requiring the user to sign multiple transactions when performing just one logical action (e.g., approving and swapping tokens), dapps can batch these together.  
**Operational**: Gas savings by cutting signature verification per transaction (21000 EOA, varies for smart wallets), other potential savings can come from subsequent storage reads (WARM_STORAGE_READ_COST=100 vs. COLD_SLOAD_COST=2100), but it depends on the transactions in the batch.

### SPECIFICATION
 `wallet_batchTransactions`
 
The method takes an array of Transactions that follow the ** EIP-1559Transaction** type definition. The method returns an array of transaction hashes, except that a smart contract wallet would return an array with a single transaction hash corresponding to the batch transaction. EOA would return transaction hashes corresponding to each transaction passed in the array.

**Parameters**  
`wallet_batchTransactions` accepts an array of transactions as a first parameter, specified by the following TypeScript type (`?` after the key means optional property):
```typescript=
type Transaction = {
    to?: string;
    value?: string;
    gas: string;
    maxPriorityFeePerGas?: string;
    maxFeePerGas?: string;
    data: string;
    nonce: number;
    chainId: string;
    accessList: {
        address: string;
        storageKeys: string[];
    }[];
};


type TransactionBatch = Array<Transaction>;
```

1. `Array` - an array of transaction objects. Transaction object has the following structure:
- `to` - (optional) 20 Bytes The address the transaction is directed to. Undefined for creation transactions.
- `value` - (optional) the value sent with this transaction
- `gas` - Transaction gas limit
- `maxPriorityFeePerGas` - Miner tip aka priority fee.
- `maxFeePerGas` - The maximum total fee per gas the sender is willing to pay (includes the network/base fee and miner/priority fee) in wei
- `data` - The hash of the invoked method signature and encoded parameters
- `nonce` - Integer of a nonce. This allows overwriting your own pending transactions that use the same nonce
- `chainId` - Chain ID that this transaction is valid on.
- `accessList` - (optional) EIP-2930 access list.

**IMPORTANT** Smart wallets only take into account `to`, `value` and `data` properties to avoid the complexity of figuring out batch transaction options from multiple transactions.

2. `Object` - (optional) Batch Options. Optionally taken into account by SC wallets.
- `gas` - (optional) Transaction gas limit
- `maxPriorityFeePerGas` - Miner tip aka priority fee.
- `maxFeePerGas` - The maximum total fee per gas the sender is willing to pay (includes the network / base fee and miner / priority fee) in wei
- `nonce` - Integer of a nonce. This allows to overwrite your own pending transactions that use the same nonce
- `chainId` - Chain ID that this transaction is valid on.
- `accessList` - (optional) EIP-2930 access list.

**Returns**  
An array of 32 Bytes transaction hashes. Smart contract wallet would return an array with a single transaction hash corresponding to the batch transaction.


**Example request**

Approve & swap USDC to ETH on 1inch in a batch
```json
{
   "id":1337,
   "jsonrpc":"2.0",
   "method":"wallet_batchTransactions",
   "params":[
      [
         {
            "to":"0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
            "data":"0x095ea7b30000000000000000000000001111111254fb6c44bac0bed2854e76f90643097d000000000000000000000000000000000000000000000000000000e8d4a51000",
            "value":"0x0",
            "gas":"0x76c0",
            "maxPriorityFeePerGas":"0x77359400",
            "maxFeePerGas":"0xBA43B7400",
            "nonce": "0x0",
            "chainId":"0x1",
            "accessList":[]
         },
         {
            "to":"0x1111111254fb6c44bAC0beD2854e76F90643097d",
            "data":"0xe449022e000000000000000000000000000000000000000000000000000000e8d4a5100000000000000000000000000000000000000000000000000c217e9eb00aecc6720000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000120000000000000000000000088e6a0c2ddd26feeb64f039a2c41296fcb3f564065575cda",
            "value":"0x0",
            "gas":"0x249F0",
            "maxPriorityFeePerGas":"0x77359400",
            "maxFeePerGas":"0xBA43B7400",
            "nonce": "0x1",
            "chainId":"0x1",
            "accessList":[]
         }
      ],
      {
            "gas": "0x30D40",
            "maxPriorityFeePerGas":"0x77359400",
            "maxFeePerGas":"0xBA43B7400",
            "nonce": "0x0",
            "chainId":"0x1",
            "accessList":[]
      }
   ]
}
```

**Example response**

- By EOA wallet
```json=
{
   "id":1337,
   "jsonrpc":"2.0",
   "result": ["0xae1bc5d7be732df6946a453b401e5dc0b581202fe851e720245998f87558924e", "0xc06d41daca84e0fb2051b7437d5041ace096588965116e57d19e23dc5c244afa"]
}
```

- By smart contract wallet with batching capabilities 
```json=
{
   "id":1337,
   "jsonrpc":"2.0",
   "result": ["0x8b6724cd7a9ffbf433900503d4844ad7e97985c68ec65fe870182773bb8b5ee8"]
}
```

### RATIONALE
The purpose of wallet_batchTransactions is to provide dapps a way to request a wallet to bundle multiple transactions for one logical action into a single batch transaction, which they would otherwise ask the user to approve one by one.

### BACKWARDS COMPATIBILITY

This isn't exactly backward compatibility, but it was a goal to make transaction parameters compatible with `eth_sendTransaction`.

### GENERAL CONSIDERATIONS

- The returned value logic is different for EOA/SC wallets (array of transaction hashes for each individual transaction vs. array with a single transaction hash for the batch transaction)

### SECURITY CONSIDERATIONS

Security considerations depend on the wallet's implementation of the method.

### REFERENCE IMPLEMENTATION

The legacy Gnosis Safe wallet supported transaction batching via a different method, `gs_multi_send` with slightly different parameters:
https://github.com/gnosis/safe-ios-legacy/blob/d94c819e1930ce7ffb8b43c0c6ac84bedfddb17d/MultisigWallet/MultisigWalletImplementations/Services/WalletConnectService.swift#L140-L151
