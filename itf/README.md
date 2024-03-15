Here is a proposed JSON Schema for the Informal Trace Format (ITF) described in the ADR document:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "#meta": {
      "type": "object"
    },
    "params": {
      "type": "array",
      "items": {
        "type": "string"  
      }
    },
    "vars": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "states": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "#meta": {
            "type": "object"
          }
        },
        "patternProperties": {
          "^(?!#).*$": {
            "oneOf": [
              {
                "type": "boolean"
              },
              {
                "type": "string"
              },
              {
                "type": "object",
                "properties": {
                  "#bigint": {
                    "type": "string",
                    "pattern": "^-?[0-9]+$"
                  }
                },
                "additionalProperties": false,
                "required": ["#bigint"]
              },
              {
                "type": "array"
              },
              {
                "type": "object",
                "patternProperties": {
                  "^(?!#).*$": {}
                },
                "additionalProperties": false
              },
              {
                "type": "object",
                "properties": {
                  "#tup": {
                    "type": "array"
                  }
                },
                "additionalProperties": false,
                "required": ["#tup"] 
              },
              {
                "type": "object",
                "properties": {
                  "#set": {
                    "type": "array"
                  }
                },
                "additionalProperties": false,
                "required": ["#set"]
              },
              {  
                "type": "object",
                "properties": {
                  "#map": {
                    "type": "array",
                    "items": {
                      "type": "array",
                      "items": {},
                      "minItems": 2,
                      "maxItems": 2
                    }
                  }
                },
                "additionalProperties": false,
                "required": ["#map"]
              },
              {
                "type": "object", 
                "properties": {
                  "#unserializable": {
                    "type": "string"
                  }
                },
                "additionalProperties": false,
                "required": ["#unserializable"]  
              }
            ]
          }
        }
      }
    },
    "loop": {
      "type": "integer",
      "minimum": 0
    }
  },
  "required": [ "vars", "states" ]
}
```

Key elements:

- The top-level trace object has properties for optional `#meta`, `params` arrays, required `vars` array, required `states` array, and optional `loop` integer
- `vars` is an array of variable name strings
- Each object in `states` array represents a state
  - State objects have `#meta` and variable name properties
  - Variable values have a complex `oneOf` allowing booleans, strings, bigints, arrays, objects, tuples, sets, maps, unserializable  
- Maps are arrays of 2-element key-value arrays
- Tuples, sets, unserializable are objects with special # property names
- Integer `loop` index points to start of loop in states array

This captures the key elements but a few open questions remain:

1. Should we allow additional unknown properties at the top-level and in states? Currently `additionalProperties: false` prohibits this.

2. The complex `oneOf` for variable values allows arbitrary nesting. Do we want to restrict the depth?

3. Referencing variable names and types between the `vars` and `states` is not enforced. We could allow any properties and just match against `vars`, or more strictly require all `vars` and only `vars` in each state.

4. Validating the specific string patterns used for bigints, tuples, sets etc could be made stricter.

Overall this provides a solid starting point capturing the hierarchical structure, but some tradeoffs between strictness and flexibility remain. With further discussion and real-world usage feedback, the schema could be refined as needed.

Proposed RFC:

# JSON Schema for Informal Trace Format (ITF)

## Introduction 
This document proposes a JSON Schema for validating execution trace files in the Informal Trace Format specified in ADR-015.

## Schema Overview
The top-level trace object contains:
- Optional `#meta` object for metadata 
- Optional `params` array of parameter names
- Required `vars` array of variable names 
- Required `states` array of state objects
- Optional `loop` integer index 

Each state object contains:
- Optional `#meta` object
- Properties corresponding to the variable names in `vars`

Variable values can be:
- Booleans
- Strings 
- Bigints encoded as `{"#bigint": "<integer>"}`
- Arrays
- Objects (records) 
- Tuples encoded as `{"#tup": [...]}`
- Sets encoded as `{"#set": [...]}`
- Maps encoded as `{"#map": [[key, value],...]}`
- Unserializable values encoded as `{"#unserializable": "<description>"}`

## Open Questions
The following points remain open for discussion:
1. Prohibiting unknown properties with `additionalProperties: false`
2. Restricting arbitrary nesting depth of variable values
3. Matching state properties strictly to declared `vars`
4. Refining string pattern validation for bigints, tuples, etc.

## Conclusion
The proposed JSON Schema provides a precise foundation for validating ITF trace files, while leaving some flexibility in the spec. Feedback from real-world usage can guide refinements to strike the right balance between strictness and ease of use. Tooling support for schema validation will aid in writing and processing ITF files.
