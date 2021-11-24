
const hre = require("hardhat");
const { displayBalance, users } = require('../../utils')
const { expect } = require('chai');
const adapterName = "DoDoProtocolAdapter";

const usdtDai = "0x1a4f8705e1c0428d020e1558a371b7e6134455a2";
let tokens = [usdtDai]


// Start test block
describe('Convex-Finance', function () {
    const protocolName = `${web3.eth.abi.encodeParameter('bytes32', web3.utils.toHex('harvest-finance'))}`;

    before(async function () {
        const { getNamedAccounts } = hre;
        console.log(await getNamedAccounts())
        this.AdapterRegistry = await ethers.getContractFactory('AdapterRegistry');
        this.adapterRegistry = await this.AdapterRegistry.deploy();
        await this.adapterRegistry.deployed();
        console.log("ADAPTER_REGISTRY", this.adapterRegistry.address);
    });

    before(async function () {
        this.Adapter = await ethers.getContractFactory(adapterName);
        this.adapter = await this.Adapter.deploy();
        await this.adapter.deployed();
        this.protocolAdapterAddress = this.adapter.address;
        console.log("ADAPTER", this.protocolAdapterAddress);
    });

    it('add adapter in registry', async function () {
        await this.adapterRegistry.addProtocolAdapter(protocolName, this.protocolAdapterAddress, tokens);
        const cProtocolName = await this.adapterRegistry._protocolAdapterNames(0);
        console.log(cProtocolName);
        expect(cProtocolName).to.equal(protocolName);
        console.log(await this.adapterRegistry.getSupportedTokens(cProtocolName))
    })

    it('retrieve returns a value previously stored', async function () {
        for (let i = 0; i < users.length; i++) {
            let balances = await this.adapterRegistry.getBalances(users[i]);
            displayBalance(users[i], balances);
        }
    });
});

