# Investment analysis of DeFi Protocols with multi chain support like Ethereum, Polygon, BSC, Terra, FTM etc

---

It provides user assets details on DeFi protocols by querying on blockchain at real time. It provides users positions in multiple verticals like
**Staking, Lending, Borrowing, Liquidity, derivatives, assets etc**.

---

# Architecture

- **Protocol Adapter** is a Interface between external protocols and adapter registry. we have different type adapter based on protocol. Ex:

**1.** staking-adapter provides user staking details protocols ex: Harvest Finance, DodoExchange

**2.** lending-adapter provides user lending details of protocols ex: Aave, Compound etc

**3.** borrowing-adapter provides user borrowing details of protocols ex: Aave, Compound etc

**4.** liquidity-adapter provides user liquidity pool details of protocols ex: Dodo Exchange, Balancer etc

**5.** derivatives-adapter provides derivate details of protocols ex: Rari Capital, BarnBridge etc.

**6.** assets-adapter provides all user holding in erc20 token formats ex: USDC, USDT, DAI etc

Each defi adaptor inherits abstract **ProtocolAdapter**

Smart Contract Example:

```solidity
abstract contract ProtocolAdapter {

    function getBalance(address token, address account) public virtual returns (int256);

    ...
}
```

Javascript Example

```typescript
abstract class ProtocolAdapter {

  getBalance(token: string, address: string, chain: string): number;

  ...
}
```

- **Adapter Registry** maintain list of all protocol adapters. User interact with adaptor registry to know the protocol balances. We can add, modify, delete adaptors from registry.

Smart Contract Example:

```solidity
abstract contract AdapterRegistry {

    function getBalances(address account) external returns (TokenBal[] memory)

    function getProtocolBalance(address account, bytes32 calldata name) returns (TokenBal[] memory)

    /**
     add token adapter
     @param : name adapter name
     @param: adapter adapter address
     @params tokens Array of supported tokens
    **/
    function addProtocol(bytes32 calldata name, address calldata adapter,address[] calldata tokens) external onlyOwner

    function updateProtocol(bytes32 calldata name, address calldata adapter,address[] calldata tokens) external onlyOwner

    function removeProtocol(bytes32 calldata name) external onlyOwner

    ...
}
```

Javascript Example

```typescript
abstract class AdapterRegistry {

    getBalances(account: string,  chain: string) : TokenBal[];

    getProtocolBalance(account: string, name: string, chain: string) : TokenBal[];

    /**
     add token adapter
     @param : name adapter name
     @param: adapter adapter address
     @params tokens Array of supported tokens
    **/
    addProtocol(name: string, adapter:string, tokens: string[],  chain: string);

    updateProtocol(name: string, adapter:string, tokens: string[],  chain: string);

    removeProtocol(name: string,  chain: string);

    ...
}
```
![Alt text](./asset/Itracker.png?raw=true "Title")

---

# General functions 

- Multi chain support

```typescript
getProvider(chain:string); <various chain provider like Ethereum, BSC, FTM, Polygon, Terra>

getContract(provider: object, abi:object, chain:string, address:string);

getTokenPrice(chain:string, address:string);

getContractAddress(chain:string, name:string);

getContractABI(chain:string, name:string);

```

- Token metadata and price support 

```typescript

 getTokenDecimals(chain:string, address:string);

 getNativeDecimal(chain);

 getTokenMetaData(chain:string, address:string): {
     name: string,
     symbol:string,
     decimal: number,
     price: number
 }


getTokenPrice(address:string);

getTokenPriceByName(name:string);

getTokenPriceChainLink(address:string[]);

getTokenPriceFromCMC(tokenId:number[]);
```

---

