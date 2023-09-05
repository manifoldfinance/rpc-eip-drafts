---
eip: 0000
title:
description:
author: Sam Bacha (@sambacha) <Additional Contributors HERE>
discussions-to: 
status:
type: Standards Track
category: Interface
created: 2022-04-25
requires: 86, 155, 695, 1193
---

# Abstract



## Motivation


## Rationale



## Specification
  
IETF: 4627, 2119, 3986

### Key Words
  
The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
[RFC-2119](https://www.ietf.org/rfc/rfc2119.txt).

### ResourceURI (string)

Uniform Resource Identifier as specified in RFC 3986, is used to identify and resolve endpoints. 
Case sensitive and MUST be case normalized as per section 6.2.2.1 of RFC 3986, m
eaning that the scheme and authority MUST be in lowercase.

### JSON-RPC 

Since JSON-RPC utilizes JSON, it has the same type system (described in
[RFC 4627](http://www.ietf.org/rfc/rfc4627.txt)). JSON can represent four primitive types (Strings,
Numbers, Booleans, and Null) and two structured types (Objects and Arrays). The term "Primitive" in
this specification references any of those four primitive JSON types. The term "Structured"
references either of the structured JSON types. Whenever this document refers to any JSON type, the
first letter is always capitalized: Object, Array, String, Number, Boolean, Null. True and False are
also capitalized.

All member names exchanged between the Client and the Server that are considered for matching of any
kind should be considered to be case-sensitive. The terms function, method, and procedure can be
assumed to be interchangeable.

The Client is defined as the origin of Request objects and the handler of Response objects. The
Server is defined as the origin of Response objects and the handler of Request objects.

### `wallet_switchNetworkRpcProvider`

#### Parameters

#### Parameters



#### Returns

  
### Examples


## Backwards Compatibility
  
*Tentative*: Will Examine more thoroughly 

Does not introduce backwards incompatibilities with existing `eth_` methods or EIP specifications

## Security Considerations



## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
