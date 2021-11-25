
const hre = require("hardhat");
const { displayBalance, users } = require('../../utils')
const { expect } = require('chai');
const adapterName = "FraxProtocolAdapter";

const uni_dai_frax = "0xF22471AC2156B489CC4a59092c56713F813ff53e";
const uni_usdc_frax = "0x3EF26504dbc8Dd7B7aa3E97Bc9f3813a9FC0B4B0";

let tokens = [uni_dai_frax, uni_usdc_frax ]


// Start test block
describe('Frax-Finance-lp', function () {
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

