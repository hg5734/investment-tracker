const hre = require("hardhat");
const { displayBalance, users } = require('../../utils')
const { expect } = require('chai');
const adapterName = "YearnProtocolAdapter";

const usdn3Crv = "0x3b96d491f067912d18563d56858ba7d6ec67a6fa";
const frax3Crv = "0xb4ada607b9d6b2c9ee07a275e9616b84ac560139";

let tokens = [usdn3Crv, frax3Crv]


// Start test block
describe('yearn-Finance', function () {
    const protocolName = `${web3.eth.abi.encodeParameter('bytes32', web3.utils.toHex('yearn-finance'))}`;

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