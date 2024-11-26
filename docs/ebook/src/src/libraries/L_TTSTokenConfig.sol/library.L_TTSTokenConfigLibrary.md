# L_TTSTokenConfigLibrary
A library for handling TTS token configurations


## Functions
### ismain

Checks if the given configuration represents a main item

*Uses assembly to perform a bitwise right shift operation*


```solidity
function ismain(uint256 config) internal pure returns (bool a);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`config`|`uint256`|The configuration value to check|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`a`|`bool`|True if the configuration represents a main item, false otherwise|


