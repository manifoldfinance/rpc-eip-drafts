# `eth_getLogs` with `blockTimestamp`

A Proposal for adding blockTimestamp to logs object returned by eth_getLogs and related requests

## [](https://ethereum-magicians.org/t/proposal-for-adding-blocktimestamp-to-logs-object-returned-by-eth-getlogs-and-related-requests/11183#motivation-1)Motivation

Currently, most contract events that act on the notion of time do not add timestamp information as it is already available on the block where the event occurs. This saves them the extra gas cost of adding timestamps to the events.

Unfortunately `eth_getLogs` do not provide the timestamp as part of the log objects returned. And so indexers that fetches these events using `eth_getLogs`, need to make one extra request for each different block to get the timestamps at which these events happen.

This significantly reduces the speed at which such an indexer can compute the state from the events. With an `eth_getLogs` you can get thousands of events and process them but for events that require timestamp information, you indeed currently need to perform thousands of requests more for it.

This is especially difficult for indexers that run in-browsers where each user would have to perform all the extra requests. Also in such an environment, [EIP-1193 8](https://eips.ethereum.org/EIPS/eip-1193) prevents them from using batch requests, which could have alleviated the issue.

Ideally, the log object returned by `eth_getLogs` would include the block’s timestamp along the block’s hash and number.

## Specification

Here is the spec for `eth_getLogs` with the added `blockTimestamp` field

### `eth_getLogs`

Returns an array of all logs matching a given filter object.

#### **Parameters**

1.  `Object` - The filter options:

-   `fromBlock`: `QUANTITY|TAG` - (optional, default: `"latest"`) Integer block number, or `"latest"` for the last mined block or `"pending"`, `"earliest"` for not yet mined transactions.
-   `toBlock`: `QUANTITY|TAG` - (optional, default: `"latest"`) Integer block number, or `"latest"` for the last mined block or `"pending"`, `"earliest"` for not yet mined transactions.
-   `address`: `DATA|Array`, 20 Bytes - (optional) Contract address or a list of addresses from which logs should originate.
-   `topics`: `Array of DATA`, - (optional) Array of 32 Bytes `DATA` topics. Topics are order-dependent. Each topic can also be an array of DATA with “or” options.
-   `blockhash`: `DATA`, 32 Bytes - (optional, **future**) With the addition of EIP-234, `blockHash` will be a new filter option which restricts the logs returned to the single block with the 32-byte hash `blockHash`. Using `blockHash` is equivalent to `fromBlock` = `toBlock` = the block number with hash `blockHash`. If `blockHash` is present in in the filter criteria, then neither `fromBlock` nor `toBlock` are allowed.

```jsonc
params: [
  {
    topics: [
      "0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b",
    ],
  },
]

```

#### **Returns**

`Array` - Array of log objects, with following params:

-   `removed`: `TAG` - `true` when the log was removed, due to a chain reorganization. `false` if its a valid log.
-   `logIndex`: `QUANTITY` - integer of the log index position in the block. `null` when its pending log.
-   `transactionIndex`: `QUANTITY` - integer of the transactions index position log was created from. `null` when its pending log.
-   `transactionHash`: `DATA`, 32 Bytes - hash of the transactions this log was created from. `null` when its pending log.
-   `blockHash`: `DATA`, 32 Bytes - hash of the block where this log was in. `null` when its pending. `null` when its pending log.
-   `blockNumber`: `QUANTITY` - the block number where this log was in. `null` when its pending. `null` when its pending log.  
-   `blockTimestamp`: `QUANTITY` - the unix timestamp for when the block where this log was in, was collated. `null` when its pending. `null` when its pending log.**
-   `address`: `DATA`, 20 Bytes - address from which this log originated.
-   `data`: `DATA` - contains one or more 32 Bytes non-indexed arguments of the log.
-   `topics`: `Array of DATA` - Array of 0 to 4 32 Bytes `DATA` of indexed log arguments. (In _solidity_: The first topic is the _hash_ of the signature of the event (e.g. `Deposit(address,bytes32,uint256)`), except you declared the event with the `anonymous` specifier.)
