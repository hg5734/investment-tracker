const hre = require("hardhat");
const { displayBalance, users } = require('../utils')
const { expect } = require('chai');
const adapterName = "HFProtocolAdapter";

const fdai = "0x15d3A64B2d5ab9E152F16593Cdebc4bB165B5B4A";
const fusdc = "0x4F7c28cCb0F1Dbd1388209C67eEc234273C878Bd";
const usdp3Crv = "0x15AEB9B209FEC67c672dBF5113827daB0b80f390";

let tokens = [fdai, fusdc, usdp3Crv]


// Start test block
describe('Harvest-Finance', function () {
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
    })

    it('retrieve returns a value previously stored', async function () {
        for (let i = 0; i < users.length; i++) {
            let balances = await this.adapterRegistry.getBalances(users[i]);
            displayBalance(users[i], balances);
        }
    });
});