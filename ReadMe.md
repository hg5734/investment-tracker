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

Each defi adapter inherits abstract **ProtocolAdapter**

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

- **Adapter Registry** maintain list of all protocol adapters. User interact with adapter registry to know the protocol balances. We can add, modify, delete adapters from registry.

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

# Technology Stack

       --------------------------------------- |---------------------------------------
       |  Technology                           | Language
       --------------------------------------- | ---------------------------------------
       | Ethereum                              | Solidity
       | Polygon                               | Solidity
       | FTM                                   | Solidity
       | BSC                                   | Solidity
       | Avalanche                             | Solidity
       | Terra                                 | Rust
       | Solana                                | RUST
       | SMS/Email Notification                | AWS SNS Services
       | Frontend                              | ReactJs
       | Monitoring Service                    | NodeJs/web3/ethers js/Mongodb
       | Reporting Service                     | NodeJs/web3/ethers Js/Mongodb
       | Price Manager Service                 | NodeJs/web3/ethers Js/Mongodb
       | API Service                           | NodeJs/web3/ethers Js/Mongodb

---

# API Service

**1. API for present Investment Report**

```javascript
endpoint -> api/v1/investment/report
Method: Get
QueryParam:
{
address : "0x7334b486828fcbe6e475ac84fff767bf0f706452",
chain: "ethereum", <ftm,polygon,bsc,ethereum,all>
type: "excel/json"
}
Response <JSON, Excel>
{
   isSuccess: true,
   result :[{
       chain: 'ethereum',
       protocol: 'harvest-finance',
       address:"0x7978783384..."
       assets: [{
           name: "DAI",
           balance: 34343,
           address:"0x7978783384...",
           balanceInUSD: 343434,
       },
       {
           name: "Uniswap ETH-USDC LP",
           balance: 34343,
           balanceInUSD: 343434,
           address:"0x7978783384...",
       }
       ...
    ]
   }]
}

```

**2. API for historical Investment Report**

```javascript
endpoint -> api/v1/investment/report

Method: Get
QueryParam:
{
address : "0x7334b486828fcbe6e475ac84fff767bf0f706452",
chain: "ethereum", <ftm,polygon,bsc,ethereum>
protocol: "dodo" <optional>, // To fetch single protocol details
type: "excel/json",
durationType: "days", // Ex: days, weekly, monthly, yearly
duration : 4 <optional>,// Ex: 4 days, 4 weeks, 4 months, 4 years
startDate: 1334114310, <optional>
endDate: 1634114310 <optional>
}

Response <JSON, Excel>
{
   isSuccess: true,
   result :[{
       chain: 'ethereum',
       protocol: 'harvest-finance',
       durationType: 'weekly
       address:"0x7978783384..."
       assets: [{
           name: "DAI",
           balance: 34343,
           address:"0x7978783384...",
           balanceInUSD: 343434,
           historicalData :[{
               date: "1634114734", //13 oct 2021
               balance: 14321244444444,
            },{
               date: "1633595910", //7 oct 2021
               balance: 12321244444444,
            },
            {
               date: "1633077510", //1 oct 2021
               balance: 14321244444444,
            }
            ...
            ]
       },
       ...
    ]
   }]
}
```
--- 

# Reporting & Monitoring Service

It provides details of investments in time frame. It's a separate service which run **cron job** periodically at background to track all protocol investments and stores data in our database to perform analysis.

This service fetch information from **Adapter Registry** for all the chains. It also monitor the balances, if balances goes down from particular threshold from protocol it alerts via SMS, Email.

![Alt text](./asset/investservice.png?raw=true "Title")

---







