const hre = require("hardhat");
const { displayBalance } = require('../utils')
const { expect } = require('chai');

const user = "0x3da9d911301f8144bdf5c3c67886e5373dcdff8e";
const adapterName = "HFProtocolAdapter";
const fweth = "0xFE09e53A81Fe2808bc493ea64319109B5bAa573e";
const ftricrypto = "0x33ED34dD7C40EF807356316B484d595dDDA832ab";
let tokens = [fweth, ftricrypto]


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
        const balances = await this.adapterRegistry.getBalances(user);
        displayBalance(balances);
    });
});