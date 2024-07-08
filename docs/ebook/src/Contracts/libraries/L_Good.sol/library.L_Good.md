# L_Good

## Functions
### getMaxTradeValue


```solidity
function getMaxTradeValue(S_GoodState storage self) internal view returns (uint128);
```

### getMaxTradeQunitity


```solidity
function getMaxTradeQunitity(S_GoodState storage self) internal view returns (uint128);
```

### updateToValueGood


```solidity
function updateToValueGood(S_GoodState storage self) internal;
```

### updateToNormalGood


```solidity
function updateToNormalGood(S_GoodState storage self) internal;
```

### updateGoodConfig


```solidity
function updateGoodConfig(S_GoodState storage _self, uint256 _goodConfig) internal;
```

### init


```solidity
function init(S_GoodState storage self, T_BalanceUINT256 _init, address _erc20address, uint256 _goodConfig) internal;
```

### swapCompute1


```solidity
function swapCompute1(swapCache memory _stepCache, T_BalanceUINT256 _limitPrice)
    internal
    pure
    returns (swapCache memory);
```

### swapCompute2


```solidity
function swapCompute2(swapCache memory _stepCache, T_BalanceUINT256 _limitPrice)
    internal
    pure
    returns (swapCache memory);
```

### swapCommit


```solidity
function swapCommit(S_GoodState storage _self, T_BalanceUINT256 _swapstate, uint128 _fee) internal;
```

### investGood


```solidity
function investGood(S_GoodState storage _self, uint128 _invest)
    internal
    returns (S_GoodInvestReturn memory investResult_);
```

### disinvestGood


```solidity
function disinvestGood(
    S_GoodState storage _self,
    S_GoodState storage _valueGoodState,
    L_Proof.S_ProofState storage _investProof,
    S_GoodDisinvestParam memory _params
) internal returns (S_GoodDisinvestReturn memory normalGoodResult1_, S_GoodDisinvestReturn memory valueGoodResult2_);
```

### collectGoodFee


```solidity
function collectGoodFee(
    S_GoodState storage _self,
    S_GoodState storage _valuegood,
    L_Proof.S_ProofState storage _investProof,
    address _gater,
    address _referal,
    uint256 _marketconfig,
    address _marketcreator
) internal returns (T_BalanceUINT256 profit);
```

### allocateFee


```solidity
function allocateFee(
    S_GoodState storage _self,
    uint128 _profit,
    uint256 _marketconfig,
    address _gater,
    address _referal,
    address _marketcreator
) private;
```

## Structs
### S_GoodState

```solidity
struct S_GoodState {
    uint256 goodConfig;
    address owner;
    address erc20address;
    T_BalanceUINT256 currentState;
    T_BalanceUINT256 investState;
    T_BalanceUINT256 feeQunitityState;
    mapping(address => uint128) fees;
}
```

### S_GoodTmpState

```solidity
struct S_GoodTmpState {
    uint256 goodConfig;
    address owner;
    address erc20address;
    T_BalanceUINT256 currentState;
    T_BalanceUINT256 investState;
    T_BalanceUINT256 feeQunitityState;
}
```

### swapCache

```solidity
struct swapCache {
    uint128 remainQuantity;
    uint128 outputQuantity;
    uint128 feeQuantity;
    uint128 swapvalue;
    T_BalanceUINT256 good1currentState;
    uint256 good1config;
    T_BalanceUINT256 good2currentState;
    uint256 good2config;
}
```

### S_GoodInvestReturn

```solidity
struct S_GoodInvestReturn {
    uint128 actualFeeQuantity;
    uint128 contructFeeQuantity;
    uint128 actualInvestValue;
    uint128 actualInvestQuantity;
}
```

### S_GoodDisinvestReturn

```solidity
struct S_GoodDisinvestReturn {
    uint128 profit;
    uint128 actual_fee;
    uint128 actualDisinvestQuantity;
}
```

### S_GoodDisinvestParam

```solidity
struct S_GoodDisinvestParam {
    uint128 _goodQuantity;
    address _gater;
    address _referal;
    uint256 _marketconfig;
    address _marketcreator;
}
```

