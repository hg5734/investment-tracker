const hre = require("hardhat");
const { displayBalance, users } = require('../../utils')
const { expect } = require('chai');
const adapterName = "SushiFarmProtocolAdapter";

let tokens = []


// Start test block
describe('Sushi-Farm', function () {
    const protocolName = `${web3.eth.abi.encodeParameter('bytes32', web3.utils.toHex('Sushi-Farm'))}`;

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
        const totalCount = (await this.adapter.getPoolLength()).toString();
        console.log(totalCount)
        for (let i = 0; i < totalCount; i++) {
            tokens.push(await this.adapter.getLpToken(i));
        }
        await this.adapterRegistry.addProtocolAdapter(protocolName, this.protocolAdapterAddress, tokens);
        const cProtocolName = await this.adapterRegistry._protocolAdapterNames(0);
        expect(cProtocolName).to.equal(protocolName);
    })

    it('retrieve returns a value previously stored', async function () {
        for (let i = 0; i < users.length; i++) {
            let balances = await this.adapterRegistry.getBalances(users[i]);
            displayBalance(users[i], balances);
        }
    });
});